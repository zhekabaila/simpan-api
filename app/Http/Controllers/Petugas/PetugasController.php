<?php

namespace App\Http\Controllers\Petugas;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Requests\ScanQrRequest;
use App\Http\Resources\DistribusiResource;
use App\Http\Resources\PenugasanPetugasResource;
use App\Models\DistribusiBansos;
use App\Models\PenugasanPetugas;
use App\Models\QrcodePenerima;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class PetugasController extends Controller
{
    public function getPenugasan(Request $request)
    {
        try {
            $user = auth()->user();
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $paginator = PenugasanPetugas::where('petugas_id', $user->id)
                ->latest('ditugaskan_pada')
                ->paginate($limit, ['*'], 'page', $page);

            Log::info('Penugasan petugas berhasil diambil', [
                'user_id' => $user->id,
                'count' => $paginator->count(),
            ]);

            return response()->json(
                PaginationHelper::format($paginator, PenugasanPetugasResource::collection($paginator))
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil penugasan', [
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

    public function detailPenugasan($id)
    {
        try {
            $user = auth()->user();
            $penugasan = PenugasanPetugas::where('id', $id)
                ->where('petugas_id', $user->id)
                ->first();

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
                'sudah_diterima'   => $distribusiData->where('status', 'diterima')->count(),
                'duplikat'         => $distribusiData->where('status', 'duplikat')->count(),
                'gagal'            => $distribusiData->where('status', 'gagal')->count(),
            ];

            Log::info('Detail penugasan berhasil diambil', [
                'user_id' => $user->id,
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

    public function scanQr(ScanQrRequest $request)
    {
        try {
            $user = auth()->user();
            $tokenQr = $request->token_qr;
            $periodeBansosId = $request->periode_bansos_id;

            // 1. Find QR code
            $qrcode = QrcodePenerima::where('token_qr', $tokenQr)->first();

            if (!$qrcode) {
                Log::warning('Scan QR gagal - token tidak ditemukan', [
                    'token' => $tokenQr,
                    'petugas_id' => $user->id,
                ]);
                return response()->json([
                    'success' => false,
                    'status' => 'gagal',
                    'message' => 'QR Code tidak ditemukan',
                    'alasan' => 'QR Code tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            // 2. Check if QR is active
            if (!$qrcode->aktif) {
                Log::warning('Scan QR gagal - QR tidak aktif', [
                    'qrcode_id' => $qrcode->id,
                    'petugas_id' => $user->id,
                ]);
                return response()->json([
                    'success' => false,
                    'status' => 'gagal',
                    'message' => 'QR Code tidak aktif',
                    'alasan' => 'QR Code tidak aktif',
                ], Response::HTTP_FORBIDDEN);
            }

            // 3. Get profil masyarakat
            $profil = $qrcode->profilMasyarakat;

            // 4. Find approved pengajuan
            $pengajuan = $profil->pengajuanBansos()
                ->where('status', 'disetujui')
                ->first();

            if (!$pengajuan) {
                Log::warning('Scan QR gagal - bukan penerima', [
                    'profil_id' => $profil->id,
                    'petugas_id' => $user->id,
                ]);
                return response()->json([
                    'success' => false,
                    'status' => 'gagal',
                    'message' => 'Masyarakat ini bukan penerima bansos yang disetujui',
                    'alasan' => 'Masyarakat ini bukan penerima bansos yang disetujui',
                ], Response::HTTP_FORBIDDEN);
            }

            // 5. Check for duplicate
            $existingDistribusi = DistribusiBansos::where('profil_masyarakat_id', $profil->id)
                ->where('periode_bansos_id', $periodeBansosId)
                ->where('status', 'diterima')
                ->first();

            if ($existingDistribusi) {
                // Create duplicate record
                DistribusiBansos::create([
                    'id' => (string) Str::uuid(),
                    'periode_bansos_id' => $periodeBansosId,
                    'profil_masyarakat_id' => $profil->id,
                    'petugas_id' => $user->id,
                    'penugasan_id' => $request->penugasan_id ?? null,
                    'token_qr_dipindai' => $tokenQr,
                    'status' => 'duplikat',
                    'alasan_gagal' => 'Bansos sudah diterima pada periode ini',
                    'latitude_scan' => $request->latitude_scan,
                    'longitude_scan' => $request->longitude_scan,
                ]);

                Log::warning('Scan QR duplikat', [
                    'profil_id' => $profil->id,
                    'periode_id' => $periodeBansosId,
                    'petugas_id' => $user->id,
                ]);

                $nikMasked = substr($profil->nik, 0, 4) . str_repeat('*', 12);

                return response()->json([
                    'success' => false,
                    'status' => 'duplikat',
                    'message' => 'Bansos sudah diterima pada periode ini',
                    'alasan' => 'Bansos sudah diterima pada periode ini',
                    'waktu_diterima' => $existingDistribusi->diterima_pada,
                    'data' => [
                        'nama' => $profil->user->nama,
                        'nik' => $nikMasked,
                        'alamat' => $profil->alamat,
                        'kelurahan' => $profil->kelurahan,
                        'kecamatan' => $profil->kecamatan,
                    ],
                ], Response::HTTP_CONFLICT);
            }

            // 6. Create success distribution record
            $distribusi = DistribusiBansos::create([
                'id' => (string) Str::uuid(),
                'periode_bansos_id' => $periodeBansosId,
                'profil_masyarakat_id' => $profil->id,
                'petugas_id' => $user->id,
                'penugasan_id' => $request->penugasan_id ?? null,
                'token_qr_dipindai' => $tokenQr,
                'status' => 'diterima',
                'latitude_scan' => $request->latitude_scan,
                'longitude_scan' => $request->longitude_scan,
            ]);

            Log::info('Scan QR berhasil - bansos diterima', [
                'profil_id' => $profil->id,
                'petugas_id' => $user->id,
                'distribusi_id' => $distribusi->id,
            ]);

            $nikMasked = substr($profil->nik, 0, 4) . str_repeat('*', 12);

            return response()->json([
                'success' => true,
                'status' => 'diterima',
                'message' => 'Bansos berhasil diterima',
                'data' => [
                    'nama' => $profil->user->nama,
                    'nik' => $nikMasked,
                    'alamat' => $profil->alamat,
                    'kelurahan' => $profil->kelurahan,
                    'kecamatan' => $profil->kecamatan,
                    'diterima_pada' => $distribusi->diterima_pada,
                ],
            ]);
        } catch (\Exception $e) {
            Log::error('Scan QR gagal - exception', [
                'token' => $request->token_qr ?? null,
                'petugas_id' => auth()->id(),
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

    public function riwayatDistribusi(Request $request)
    {
        try {
            $user = auth()->user();
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            // 1. Buat Base Query (Tanpa filter status) - only for approved applicants
            $baseQuery = DistribusiBansos::where('petugas_id', $user->id)
                ->whereHas('profilMasyarakat.pengajuanBansos', function ($q) {
                    $q->where('status', 'disetujui');
                });

            // Filter berdasarkan tanggal jika ada (berlaku untuk statistik juga)
            if ($request->has('tanggal') && $request->tanggal) {
                $baseQuery->whereDate('diterima_pada', $request->tanggal);
            }

            // 2. Buat query baru untuk pagination agar tidak mengganggu baseQuery
            $queryPagination = clone $baseQuery;

            // Terapkan filter status HANYA untuk daftar yang ditampilkan (pagination)
            if ($request->has('status') && $request->status) {
                $queryPagination->where('status', $request->status);
            }

            $paginator = $queryPagination->latest('diterima_pada')
                ->paginate($limit, ['*'], 'page', $page);

            // 3. Hitung statistik menggunakan clone dari baseQuery
            $statistik = [
                'total'          => (clone $baseQuery)->count(),
                'total_diterima' => (clone $baseQuery)->where('status', 'diterima')->count(),
                'total_gagal'    => (clone $baseQuery)->where('status', 'gagal')->count(),
                'total_duplikat' => (clone $baseQuery)->where('status', 'duplikat')->count(),
            ];

            Log::info('Riwayat distribusi petugas berhasil diambil', [
                'user_id' => $user->id,
                'count' => $paginator->count(),
                'statistik' => $statistik
            ]);

            return response()->json(
                PaginationHelper::format($paginator, DistribusiResource::collection($paginator), [
                    'statistik' => $statistik
                ])
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil riwayat distribusi', [
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
}
