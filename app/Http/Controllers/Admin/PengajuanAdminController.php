<?php

namespace App\Http\Controllers\Admin;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Requests\TolakPengajuanRequest;
use App\Http\Resources\PengajuanBansosResource;
use App\Models\PengajuanBansos;
use App\Services\NotifikasiService;
use App\Services\QrCodeService;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

class PengajuanAdminController extends Controller
{
    public function __construct(
        private QrCodeService $qrCodeService,
        private NotifikasiService $notifikasiService,
    ) {}

    public function list(Request $request)
    {
        try {
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $query = PengajuanBansos::with('profilMasyarakat.user', 'ditinjauOleh');

            // Filter by status
            if ($request->has('status') && $request->status) {
                $query->where('status', $request->status);
            }

            // Search by nama or NIK
            if ($request->has('search') && $request->search) {
                $search = $request->search;
                $query->whereHas('profilMasyarakat.user', function ($q) use ($search) {
                    $q->where('nama', 'like', "%{$search}%");
                })->orWhereHas('profilMasyarakat', function ($q) use ($search) {
                    $q->where('nik', 'like', "%{$search}%");
                });
            }

            $paginator = $query->latest('diajukan_pada')
                ->paginate($limit, ['*'], 'page', $page);

            Log::info('Daftar pengajuan berhasil diambil', [
                'user_id' => auth()->id(),
                'count' => $paginator->count(),
            ]);

            return response()->json(
                PaginationHelper::format($paginator, PengajuanBansosResource::collection($paginator))
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil daftar pengajuan', [
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
            $pengajuan = PengajuanBansos::with(
                'profilMasyarakat.user',
                'profilMasyarakat.fotoRumah',
                'ditinjauOleh'
            )->find($id);

            if (!$pengajuan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            Log::info('Detail pengajuan berhasil diambil', [
                'user_id' => auth()->id(),
                'pengajuan_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Detail pengajuan berhasil diambil',
                'data' => new PengajuanBansosResource($pengajuan),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil detail pengajuan', [
                'user_id' => auth()->id(),
                'pengajuan_id' => $id ?? null,
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

    public function approve($id)
    {
        try {
            $user = auth()->user();
            $pengajuan = PengajuanBansos::with('profilMasyarakat.user')->find($id);

            if (!$pengajuan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            if ($pengajuan->status === 'disetujui') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan sudah disetujui sebelumnya',
                ], Response::HTTP_BAD_REQUEST);
            }

            DB::beginTransaction();

            // Update pengajuan status
            $pengajuan->update([
                'status' => 'disetujui',
                'ditinjau_oleh' => $user->id,
                'ditinjau_pada' => now(),
            ]);

            // Generate QR Code
            $qrcode = $this->qrCodeService->generate($pengajuan->profil_masyarakat_id);

            DB::commit();

            // Send approval notification
            try {
                $this->notifikasiService->kirim(
                    $pengajuan->profilMasyarakat->user_id,
                    'Pengajuan Bansos Disetujui',
                    "Selamat! Pengajuan bansos Anda dengan nomor {$pengajuan->nomor_pengajuan} telah DISETUJUI. QR Code Anda sudah tersedia di aplikasi.",
                    'status_pengajuan',
                    $pengajuan->id,
                    'pengajuan_bansos'
                );
            } catch (\Exception $e) {
                Log::error('Gagal mengirim notifikasi approval', [
                    'pengajuan_id' => $pengajuan->id,
                    'error' => $e->getMessage(),
                ]);
            }

            // Send QR ready notification
            try {
                $this->notifikasiService->kirim(
                    $pengajuan->profilMasyarakat->user_id,
                    'QR Code Anda Sudah Siap',
                    'QR Code penerima bansos Anda sudah siap. Silakan buka aplikasi untuk menampilkan QR Code saat distribusi.',
                    'qr_siap',
                    $pengajuan->id,
                    'pengajuan_bansos'
                );
            } catch (\Exception $e) {
                Log::error('Gagal mengirim notifikasi QR ready', [
                    'pengajuan_id' => $pengajuan->id,
                    'error' => $e->getMessage(),
                ]);
            }

            Log::info('Pengajuan berhasil disetujui', [
                'user_id' => $user->id,
                'pengajuan_id' => $id,
                'nomor_pengajuan' => $pengajuan->nomor_pengajuan,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pengajuan berhasil disetujui',
                'data' => new PengajuanBansosResource($pengajuan),
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Gagal menyetujui pengajuan', [
                'user_id' => auth()->id(),
                'pengajuan_id' => $id ?? null,
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

    public function review($id, Request $request)
    {
        try {
            $user = auth()->user();
            $pengajuan = PengajuanBansos::with('profilMasyarakat.user')->find($id);

            if (!$pengajuan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            if ($pengajuan->status === 'disetujui') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan sudah disetujui sebelumnya',
                ], Response::HTTP_BAD_REQUEST);
            }

            if ($pengajuan->status === 'ditolak') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan sudah ditolak sebelumnya',
                ], Response::HTTP_BAD_REQUEST);
            }

            DB::beginTransaction();

            // Update pengajuan status to "ditinjau" (under review)
            $pengajuan->update([
                'status' => 'ditinjau',
                'ditinjau_oleh' => $user->id,
                'ditinjau_pada' => now(),
            ]);

            DB::commit();

            // Send review notification
            try {
                $this->notifikasiService->kirim(
                    $pengajuan->profilMasyarakat->user_id,
                    'Pengajuan Bansos Sedang Ditinjau',
                    "Pengajuan bansos Anda dengan nomor {$pengajuan->nomor_pengajuan} sedang dalam proses tinjauan. Kami akan segera memberikan keputusan.",
                    'status_pengajuan',
                    $pengajuan->id,
                    'pengajuan_bansos'
                );
            } catch (\Exception $e) {
                Log::error('Gagal mengirim notifikasi review', [
                    'pengajuan_id' => $pengajuan->id,
                    'error' => $e->getMessage(),
                ]);
            }

            Log::info('Pengajuan sedang ditinjau', [
                'user_id' => $user->id,
                'pengajuan_id' => $id,
                'nomor_pengajuan' => $pengajuan->nomor_pengajuan,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pengajuan berhasil diubah status menjadi ditinjau',
                'data' => new PengajuanBansosResource($pengajuan),
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Gagal meninjau pengajuan', [
                'user_id' => auth()->id(),
                'pengajuan_id' => $id ?? null,
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

    public function reject($id, TolakPengajuanRequest $request)
    {
        try {
            $user = auth()->user();
            $pengajuan = PengajuanBansos::with('profilMasyarakat.user')->find($id);

            if (!$pengajuan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            if ($pengajuan->status === 'ditolak') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan sudah ditolak sebelumnya',
                ], Response::HTTP_BAD_REQUEST);
            }

            // Update pengajuan status
            $pengajuan->update([
                'status' => 'ditolak',
                'catatan_admin' => $request->catatan_admin,
                'ditinjau_oleh' => $user->id,
                'ditinjau_pada' => now(),
            ]);

            // Send rejection notification
            try {
                $this->notifikasiService->kirim(
                    $pengajuan->profilMasyarakat->user_id,
                    'Pengajuan Bansos Ditolak',
                    "Mohon maaf, pengajuan bansos Anda dengan nomor {$pengajuan->nomor_pengajuan} DITOLAK. Alasan: {$request->catatan_admin}",
                    'status_pengajuan',
                    $pengajuan->id,
                    'pengajuan_bansos'
                );
            } catch (\Exception $e) {
                Log::error('Gagal mengirim notifikasi rejection', [
                    'pengajuan_id' => $pengajuan->id,
                    'error' => $e->getMessage(),
                ]);
            }

            Log::info('Pengajuan berhasil ditolak', [
                'user_id' => $user->id,
                'pengajuan_id' => $id,
                'nomor_pengajuan' => $pengajuan->nomor_pengajuan,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pengajuan berhasil ditolak',
                'data' => new PengajuanBansosResource($pengajuan),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menolak pengajuan', [
                'user_id' => auth()->id(),
                'pengajuan_id' => $id ?? null,
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
