<?php

namespace App\Http\Controllers\Admin;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Requests\PenugasanPetugasRequest;
use App\Http\Resources\PenugasanPetugasResource;
use App\Models\DistribusiBansos;
use App\Models\PenugasanPetugas;
use App\Models\User;
use App\Services\NotifikasiService;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class PenugasanAdminController extends Controller
{
    public function __construct(
        private NotifikasiService $notifikasiService,
    ) {}

    public function list(Request $request)
    {
        try {
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $query = PenugasanPetugas::with('periodeBansos', 'petugas', 'ditugaskanOleh');

            // Filter by periode
            if ($request->has('periode_id') && $request->periode_id) {
                $query->where('periode_bansos_id', $request->periode_id);
            }

            // Filter by petugas
            if ($request->has('petugas_id') && $request->petugas_id) {
                $query->where('petugas_id', $request->petugas_id);
            }

            $paginator = $query->latest('ditugaskan_pada')
                ->paginate($limit, ['*'], 'page', $page);

            Log::info('Daftar penugasan berhasil diambil', [
                'user_id' => auth()->id(),
                'count' => $paginator->count(),
            ]);

            return response()->json(
                PaginationHelper::format($paginator, PenugasanPetugasResource::collection($paginator))
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil daftar penugasan', [
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

    public function create(PenugasanPetugasRequest $request)
    {
        try {
            $user = auth()->user();

            // Validate petugas exists and has petugas role
            $petugas = User::find($request->petugas_id);
            if (!$petugas || $petugas->role !== "petugas") {
                return response()->json([
                    'success' => false,
                    'message' => 'User bukan petugas',
                ], Response::HTTP_BAD_REQUEST);
            }

            // Validate periode exists
            $periodeBaru = \App\Models\PeriodeBansos::find($request->periode_bansos_id);
            if (!$periodeBaru) {
                return response()->json([
                    'success' => false,
                    'message' => 'Periode tidak ditemukan',
                ], Response::HTTP_BAD_REQUEST);
            }

            // Check if petugas has any active periods assigned
            $penugasanAktif = PenugasanPetugas::where('petugas_id', $request->petugas_id)
                ->whereHas('periodeBansos', function ($query) {
                    $query->where('status', 'aktif');
                })
                ->first();

            // Validate periode has "akan_datang" status
            if ($periodeBaru->status !== 'akan_datang' && $penugasanAktif) {
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya periode dengan status "akan_datang" yang dapat ditugaskan',
                ], Response::HTTP_BAD_REQUEST);
            }

            // if ($penugasanAktif) {
            //     $periodeAktif = $penugasanAktif->periodeBansos;
            //     return response()->json([
            //         'success' => false,
            //         'message' => "Petugas masih memiliki periode yang aktif: {$periodeAktif->nama_periode}. Selesaikan periode ini terlebih dahulu sebelum menugaskan periode baru.",
            //         'data' => [
            //             'periode_aktif_id' => $periodeAktif->id,
            //             'periode_aktif_nama' => $periodeAktif->nama_periode,
            //         ],
            //     ], Response::HTTP_BAD_REQUEST);
            // }

            $penugasan = PenugasanPetugas::create([
                'id' => (string) Str::uuid(),
                'periode_bansos_id' => $request->periode_bansos_id,
                'petugas_id' => $request->petugas_id,
                'ditugaskan_oleh' => $user->id,
                'catatan' => $request->catatan,
            ]);

            // Send notification
            try {
                $periodeName = $penugasan->periodeBansos->nama_periode;
                $wilayah = $request->deskripsi_wilayah ?? 'wilayah yang ditentukan';
                $formattedPesanPenugasan = "*Penugasan Distribusi Baru*\n\nAnda mendapat penugasan distribusi bansos untuk periode `{$periodeName}` di wilayah __{$wilayah}__.\n\nSilakan cek detail penugasan di aplikasi.";
                $this->notifikasiService->kirim(
                    $request->petugas_id,
                    'Penugasan Distribusi Baru',
                    $formattedPesanPenugasan,
                    'jadwal_distribusi',
                    $penugasan->id,
                    'penugasan_petugas'
                );
            } catch (\Exception $e) {
                Log::error('Gagal mengirim notifikasi penugasan', [
                    'penugasan_id' => $penugasan->id,
                    'error' => $e->getMessage(),
                ]);
            }

            Log::info('Penugasan berhasil dibuat', [
                'user_id' => $user->id,
                'penugasan_id' => $penugasan->id,
                'petugas_id' => $request->petugas_id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Penugasan berhasil dibuat',
                'data' => new PenugasanPetugasResource($penugasan),
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            Log::error('Gagal membuat penugasan', [
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
            $penugasan = PenugasanPetugas::with('periodeBansos', 'petugas', 'ditugaskanOleh')->find($id);

            if (!$penugasan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Penugasan tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            // Get distribution data only for approved applicants
            $distribusiData = DistribusiBansos::where('penugasan_id', $id)
                ->whereHas('profilMasyarakat.pengajuanBansos', function ($q) {
                    $q->where('status', 'disetujui');
                })
                ->get();

            $statistik = [
                'total_distribusi' => $distribusiData->count(),
                'sudah_diterima' => $distribusiData->where('status', 'diterima')->count(),
                'duplikat' => $distribusiData->where('status', 'duplikat')->count(),
                'gagal' => $distribusiData->where('status', 'gagal')->count(),
            ];

            Log::info('Detail penugasan berhasil diambil', [
                'user_id' => auth()->id(),
                'penugasan_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Detail penugasan berhasil diambil',
                'data' => [
                    'penugasan' => new PenugasanPetugasResource($penugasan),
                    'statistik' => $statistik,
                ],
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil detail penugasan', [
                'user_id' => auth()->id(),
                'penugasan_id' => $id ?? null,
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

    public function update($id, PenugasanPetugasRequest $request)
    {
        try {
            $penugasan = PenugasanPetugas::find($id);

            if (!$penugasan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Penugasan tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            $penugasan->update([
                'catatan' => $request->catatan,
                'updated_at' => now(),
            ]);

            Log::info('Penugasan berhasil diupdate', [
                'user_id' => auth()->id(),
                'penugasan_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Penugasan berhasil diupdate',
                'data' => new PenugasanPetugasResource($penugasan),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengupdate penugasan', [
                'user_id' => auth()->id(),
                'penugasan_id' => $id ?? null,
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

    public function delete($id)
    {
        try {
            $penugasan = PenugasanPetugas::find($id);

            if (!$penugasan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Penugasan tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            $penugasan->delete();

            Log::info('Penugasan berhasil dihapus', [
                'user_id' => auth()->id(),
                'penugasan_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Penugasan berhasil dihapus',
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menghapus penugasan', [
                'user_id' => auth()->id(),
                'penugasan_id' => $id ?? null,
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
