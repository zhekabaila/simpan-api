<?php

namespace App\Http\Controllers\Admin;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Requests\CreateUserWithProfilRequest;
use App\Http\Requests\CreatePetugasUserRequest;
use App\Http\Requests\ResetUserPasswordRequest;
use App\Http\Resources\UserResource;
use App\Models\DistribusiBansos;
use App\Models\ProfilMasyarakat;
use App\Models\ProfilPetugas;
use App\Models\User;
use App\Services\EvolutionApiService;
use App\Services\NotifikasiService;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PenggunaAdminController extends Controller
{
    public function __construct(
        private NotifikasiService $notifikasiService,
    ) {}

    public function list(Request $request)
    {
        try {
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $query = User::query()
                ->with(['profilMasyarakat', 'profilPetugas']);

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
            $relations = [
                'profilMasyarakat' => function ($query) {
                    $query->with(['fotoRumah', 'pengajuanBansos', 'qrcodePenerima', 'distribusiBansos']);
                },
                'profilPetugas',
                'notifikasi',
            ];

            // Add penugasan if user is petugas
            $user = User::with($relations)->find($id);

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            // Load penugasan if role is petugas
            if ($user->role === 'petugas') {
                $user->load('profilPetugas', 'penugasanPetugas.periodeBansos');
            }

            // Load periode jika user adalah admin
            if ($user->role === 'admin') {
                $user->load('periodeBansos');
            }

            Log::info('Detail pengguna berhasil diambil', [
                'user_id' => auth()->id(),
                'detail_user_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Detail pengguna berhasil diambil',
                'data' => [
                    'user' => new UserResource($user),
                    'summary' => [
                        'role' => $user->role,
                        'aktif' => $user->aktif,
                        'has_profile' => $user->profilMasyarakat !== null,
                        'total_notifications' => $user->notifikasi->count(),
                        'unread_notifications' => $user->notifikasi->where('sudah_dibaca', false)->count(),
                        'stats' => $this->getStatsByRole($user),
                    ],
                ],
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

    private function getStatsByRole($user)
    {
        $stats = [];

        if ($user->role === 'masyarakat' && $user->profilMasyarakat) {
            // Only count distributions for approved applications
            $approvedPengajuan = $user->profilMasyarakat->pengajuanBansos->where('status', 'disetujui')->first();
            $distribusiDiterima = $approvedPengajuan ?
                DistribusiBansos::where('profil_masyarakat_id', $user->profilMasyarakat->id)
                ->where('status', 'diterima')
                ->count() : 0;
            $distribusiGagal = $approvedPengajuan ?
                DistribusiBansos::where('profil_masyarakat_id', $user->profilMasyarakat->id)
                ->where('status', 'gagal')
                ->count() : 0;

            $stats = [
                'total_pengajuan' => $user->profilMasyarakat->pengajuanBansos->count(),
                'pengajuan_disetujui' => $user->profilMasyarakat->pengajuanBansos->where('status', 'disetujui')->count(),
                'pengajuan_ditolak' => $user->profilMasyarakat->pengajuanBansos->where('status', 'ditolak')->count(),
                'pengajuan_menunggu' => $user->profilMasyarakat->pengajuanBansos->where('status', 'menunggu')->count(),
                'total_foto_rumah' => $user->profilMasyarakat->fotoRumah->count(),
                'total_distribusi_diterima' => $distribusiDiterima,
                'total_distribusi_gagal' => $distribusiGagal,
                'has_qrcode' => $user->profilMasyarakat->qrcodePenerima !== null,
            ];
        } elseif ($user->role === 'petugas') {
            $penugasan = $user->penugasanPetugas ?? collect();
            $stats = [
                'total_penugasan' => $penugasan->count(),
                'penugasan_ditugaskan' => $penugasan->where('status', 'ditugaskan')->count(),
                'penugasan_selesai' => $penugasan->where('status', 'selesai')->count(),
            ];
        } elseif ($user->role === 'admin') {
            $periode = $user->periodeBansos ?? collect();
            $stats = [
                'total_periode_dibuat' => $periode->count(),
                'periode_akan_datang' => $periode->where('status', 'akan_datang')->count(),
                'periode_aktif' => $periode->where('status', 'aktif')->count(),
                'periode_selesai' => $periode->where('status', 'selesai')->count(),
            ];
        }

        return $stats;
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
            // Verify WhatsApp number first
            $evolutionService = new EvolutionApiService();
            if (!$evolutionService->checkWhatsAppNumber($request->nomor_telepon)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Nomor WhatsApp tidak valid atau tidak terdaftar di WhatsApp. Silakan gunakan nomor WhatsApp yang aktif.',
                ], Response::HTTP_UNPROCESSABLE_ENTITY);
            }

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

            // Send notification to masyarakat
            try {
                $formattedPesanMasyarakat = "Selamat! Akun Anda telah berhasil dibuat oleh admin.\n\n*Informasi Login:*\n📧 Email: {$user->email}\n🔐 Password: {$request->password}\n📱 Nomor WhatsApp: {$request->nomor_telepon}\n\nAnda sekarang dapat login dan mengakses aplikasi SIMPAN.\n\n⚠️ _Kami sarankan Anda mengubah password dan nomor WhatsApp ini setelah login pertama kali di halaman profil._\n\nUntuk login, kunjungi: https://simpan.coreapps.web.id";
                $this->notifikasiService->kirim(
                    $user->id,
                    'Akun Anda Telah Dibuat',
                    $formattedPesanMasyarakat,
                    'umum',
                    $user->id,
                    'pengguna'
                );
            } catch (\Exception $e) {
                Log::error('Gagal mengirim notifikasi pembuatan akun masyarakat', [
                    'user_id' => $user->id,
                    'error' => $e->getMessage(),
                ]);
            }

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

    public function createPetugasUser(CreatePetugasUserRequest $request)
    {
        try {
            // Verify WhatsApp number first
            $evolutionService = new EvolutionApiService();
            if (!$evolutionService->checkWhatsAppNumber($request->nomor_telepon)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Nomor WhatsApp petugas tidak valid atau tidak terdaftar di WhatsApp. Silakan gunakan nomor WhatsApp yang aktif.',
                ], Response::HTTP_UNPROCESSABLE_ENTITY);
            }

            DB::beginTransaction();

            // Create user account
            $user = User::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => bcrypt($request->password),
                'role' => 'petugas',
                'aktif' => true,
            ]);

            // Create profil petugas
            $profilData = [
                'user_id' => $user->id,
                'nomor_telepon' => $request->nomor_telepon,
            ];

            // Add optional fields if provided
            $optionalFields = [
                'alamat',
                'latitude',
                'longitude',
            ];

            foreach ($optionalFields as $field) {
                if ($request->has($field) && $request->input($field) !== null) {
                    $profilData[$field] = $request->input($field);
                }
            }

            ProfilPetugas::create($profilData);

            DB::commit();

            Log::info('User petugas berhasil dibuat oleh admin', [
                'admin_id' => auth()->id(),
                'petugas_id' => $user->id,
                'email' => $user->email,
            ]);

            // Send notification to petugas
            try {
                $formattedPesanPetugas = "Selamat! Akun petugas Anda telah berhasil dibuat oleh admin.\n\n*Informasi Login:*\n📧 Email: {$user->email}\n🔐 Password: {$request->password}\n📱 Nomor WhatsApp: {$request->nomor_telepon}\n\nAnda sekarang dapat login dan mengakses aplikasi SIMPAN untuk melihat penugasan distribusi.\n\n⚠️ _Kami sarankan Anda mengubah password dan nomor WhatsApp ini setelah login pertama kali di halaman profil._\n\nUntuk login, kunjungi: https://simpan.coreapps.web.id";
                $this->notifikasiService->kirim(
                    $user->id,
                    'Akun Petugas Anda Telah Dibuat',
                    $formattedPesanPetugas,
                    'umum',
                    $user->id,
                    'pengguna'
                );
            } catch (\Exception $e) {
                Log::error('Gagal mengirim notifikasi pembuatan akun petugas', [
                    'user_id' => $user->id,
                    'error' => $e->getMessage(),
                ]);
            }

            return response()->json([
                'success' => true,
                'message' => 'User petugas berhasil dibuat',
                'data' => new UserResource($user->load('profilPetugas')),
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            DB::rollBack();

            Log::error('Gagal membuat user petugas', [
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

    public function resetUserPassword($id, ResetUserPasswordRequest $request)
    {
        try {
            $user = User::find($id);

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            // Only allow reset for masyarakat and petugas roles
            if (!in_array($user->role, ['masyarakat', 'petugas'])) {
                return response()->json([
                    'success' => false,
                    'message' => 'Reset password hanya dapat dilakukan untuk user masyarakat dan petugas',
                ], Response::HTTP_FORBIDDEN);
            }

            $user->update([
                'password' => bcrypt($request->password),
            ]);

            Log::info('Password user berhasil direset oleh admin', [
                'admin_id' => auth()->id(),
                'user_id' => $id,
                'user_role' => $user->role,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Password user berhasil direset',
                'data' => new UserResource($user),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mereset password user', [
                'admin_id' => auth()->id(),
                'user_id' => $id ?? null,
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
