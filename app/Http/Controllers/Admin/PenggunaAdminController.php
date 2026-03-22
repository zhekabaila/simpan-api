<?php

namespace App\Http\Controllers\Admin;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Requests\CreateUserWithProfilRequest;
use App\Http\Resources\UserResource;
use App\Models\ProfilMasyarakat;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PenggunaAdminController extends Controller
{
    public function list(Request $request)
    {
        try {
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $query = User::query();

            if ($request->has('role') && $request->role) {
                $query->where('role', $request->role);
            }

            if ($request->has('aktif') !== false && $request->input('aktif') !== null) {
                $query->where('aktif', (bool) $request->input('aktif'));
            }

            $paginator = $query->latest('created_at')
                ->paginate($limit, ['*'], 'page', $page);

            Log::info('Daftar pengguna berhasil diambil', [
                'user_id' => auth()->id(),
                'count' => $paginator->count(),
            ]);

            return response()->json(
                PaginationHelper::format($paginator, UserResource::collection($paginator))
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil daftar pengguna', [
                'user_id' => auth()->id(),
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function detail($id)
    {
        try {
            $user = User::with('roles', 'profilMasyarakat')->find($id);

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            Log::info('Detail pengguna berhasil diambil', [
                'user_id' => auth()->id(),
                'detail_user_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Detail pengguna berhasil diambil',
                'data' => new UserResource($user),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil detail pengguna', [
                'user_id' => auth()->id(),
                'detail_user_id' => $id ?? null,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function toggleAktif($id)
    {
        try {
            $user = User::find($id);

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            $user->update(['aktif' => !$user->aktif]);

            Log::info('Status user berhasil diubah', [
                'user_id' => auth()->id(),
                'target_user_id' => $id,
                'new_aktif' => $user->aktif,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Status user berhasil diubah',
                'data' => new UserResource($user),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengubah status user', [
                'user_id' => auth()->id(),
                'target_user_id' => $id ?? null,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function createUserWithProfile(CreateUserWithProfilRequest $request)
    {
        try {
            DB::beginTransaction();

            // Create user account
            $user = User::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => bcrypt($request->password),
                'role' => $request->input('role', 'masyarakat'),
                'aktif' => true,
            ]);

            // Create profil masyarakat
            $profilData = [
                'user_id' => $user->id,
                'nik' => $request->nik,
                'nama' => $request->nama,
                'nomor_telepon' => $request->nomor_telepon,
            ];

            // Add optional fields if provided
            $optionalFields = [
                'tanggal_lahir',
                'jenis_kelamin',
                'alamat',
                'rt',
                'rw',
                'kelurahan',
                'kecamatan',
                'kota',
                'provinsi',
                'latitude',
                'longitude',
                'status_pernikahan',
                'jumlah_tanggungan',
                'status_pekerjaan',
                'penghasilan_bulanan',
                'status_kepemilikan_rumah',
            ];

            foreach ($optionalFields as $field) {
                if ($request->has($field) && $request->input($field) !== null) {
                    $profilData[$field] = $request->input($field);
                }
            }

            ProfilMasyarakat::create($profilData);

            DB::commit();

            Log::info('Pengguna dan profil masyarakat berhasil dibuat oleh admin', [
                'admin_id' => auth()->id(),
                'user_id' => $user->id,
                'email' => $user->email,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pengguna dan profil masyarakat berhasil dibuat',
                'data' => new UserResource($user->load('profilMasyarakat')),
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            DB::rollBack();

            Log::error('Gagal membuat pengguna dan profil masyarakat', [
                'admin_id' => auth()->id(),
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
