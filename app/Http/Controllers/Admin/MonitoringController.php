<?php

namespace App\Http\Controllers\Admin;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Models\DistribusiBansos;
use App\Models\PengajuanBansos;
use App\Models\PeriodeBansos;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class MonitoringController extends Controller
{
    public function statistik()
    {
        try {
            // Get current active periode
            $periodeBansos = PeriodeBansos::where('status', 'aktif')->first();

            $totalPengajuan = PengajuanBansos::count();
            $pengajuanDisetujui = PengajuanBansos::where('status', 'disetujui')->count();
            $pengajuanDitolak = PengajuanBansos::where('status', 'ditolak')->count();
            $pengajuanMenunggu = PengajuanBansos::where('status', 'menunggu')->count();

            $distribusiData = [
                'total_distribusi' => 0,
                'sudah_diterima' => 0,
                'belum_diterima' => 0,
            ];

            if ($periodeBansos) {
                $distribusiDiterima = DistribusiBansos::where('periode_bansos_id', $periodeBansos->id)
                    ->where('status', 'diterima')
                    ->count();

                $distribusiTotal = PengajuanBansos::where('status', 'disetujui')->count();

                $distribusiData = [
                    'total_distribusi' => $distribusiTotal,
                    'sudah_diterima' => $distribusiDiterima,
                    'belum_diterima' => $distribusiTotal - $distribusiDiterima,
                ];
            }

            Log::info('Statistik monitoring berhasil diambil', [
                'user_id' => auth()->id(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Statistik berhasil diambil',
                'data' => [
                    'pengajuan' => [
                        'total' => $totalPengajuan,
                        'disetujui' => $pengajuanDisetujui,
                        'ditolak' => $pengajuanDitolak,
                        'menunggu' => $pengajuanMenunggu,
                    ],
                    'distribusi' => $distribusiData,
                    'periode_aktif' => $periodeBansos ? [
                        'id' => $periodeBansos->id,
                        'nama' => $periodeBansos->nama_periode,
                        'status' => $periodeBansos->status,
                        'tanggal_mulai' => $periodeBansos->tanggal_mulai,
                        'tanggal_selesai' => $periodeBansos->tanggal_selesai,
                    ] : null,
                ],
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil statistik', [
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

    public function distribusi($periodeId, Request $request)
    {
        try {
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $query = DistribusiBansos::where('periode_bansos_id', $periodeId)
                ->with('profilMasyarakat.user', 'petugas');

            // Filter by status penerimaan
            if ($request->has('status') && $request->status) {
                if ($request->status === 'sudah_menerima') {
                    $query->where('status', 'diterima');
                } elseif ($request->status === 'belum_menerima') {
                    $query->where('status', '!=', 'diterima');
                }
            }

            // Filter by kota
            if ($request->has('kota') && $request->kota) {
                $query->whereHas('profilMasyarakat', function ($q) use ($request) {
                    $q->where('kota', $request->kota);
                });
            }

            // Filter by kecamatan
            if ($request->has('kecamatan') && $request->kecamatan) {
                $query->whereHas('profilMasyarakat', function ($q) use ($request) {
                    $q->where('kecamatan', $request->kecamatan);
                });
            }

            $paginator = $query->latest('diterima_pada')
                ->paginate($limit, ['*'], 'page', $page);

            $data = $paginator->map(function ($distribusi) {
                $nik = $distribusi->profilMasyarakat->nik;
                $nikMasked = substr($nik, 0, 4) . str_repeat('*', 12);

                return [
                    'id' => $distribusi->id,
                    'profil_masyarakat_id' => $distribusi->profil_masyarakat_id,
                    'nama' => $distribusi->profilMasyarakat->user->nama,
                    'nik' => $nikMasked,
                    'alamat' => $distribusi->profilMasyarakat->alamat,
                    'kota' => $distribusi->profilMasyarakat->kota,
                    'kecamatan' => $distribusi->profilMasyarakat->kecamatan,
                    'status_penerimaan' => $distribusi->status === 'diterima' ? 'sudah_menerima' : 'belum_menerima',
                    'diterima_pada' => $distribusi->diterima_pada,
                    'petugas' => [
                        'id' => $distribusi->petugas->id,
                        'nama' => $distribusi->petugas->nama,
                    ],
                ];
            });

            Log::info('Distribusi periode berhasil diambil', [
                'user_id' => auth()->id(),
                'periode_id' => $periodeId,
                'count' => $paginator->count(),
            ]);

            return response()->json(
                PaginationHelper::format($paginator, $data->toArray())
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil distribusi', [
                'user_id' => auth()->id(),
                'periode_id' => $periodeId ?? null,
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

    public function peta($periodeId)
    {
        try {
            $distribusi = DistribusiBansos::where('periode_bansos_id', $periodeId)
                ->with('profilMasyarakat.user')
                ->get();

            $data = $distribusi->map(function ($d) {
                return [
                    'profil_masyarakat_id' => $d->profil_masyarakat_id,
                    'nama' => $d->profilMasyarakat->user->nama,
                    'latitude' => (float) $d->profilMasyarakat->latitude,
                    'longitude' => (float) $d->profilMasyarakat->longitude,
                    'status_penerimaan' => $d->status === 'diterima' ? 'sudah_menerima' : 'belum_menerima',
                    'diterima_pada' => $d->diterima_pada,
                ];
            })->filter(function ($item) {
                return $item['latitude'] && $item['longitude'];
            });

            Log::info('Data peta berhasil diambil', [
                'user_id' => auth()->id(),
                'periode_id' => $periodeId,
                'count' => $data->count(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Data peta berhasil diambil',
                'data' => $data->values(),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil data peta', [
                'user_id' => auth()->id(),
                'periode_id' => $periodeId ?? null,
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

    public function distribusiByDate(Request $request)
    {
        try {
            // Validate dates
            $startDate = $request->input('start_date');
            $endDate = $request->input('end_date');

            if (!$startDate || !$endDate) {
                return response()->json([
                    'success' => false,
                    'message' => 'Parameter start_date dan end_date diperlukan',
                ], Response::HTTP_BAD_REQUEST);
            }

            // Parse dates
            try {
                $start = Carbon::createFromFormat('Y-m-d', $startDate)->startOfDay();
                $end = Carbon::createFromFormat('Y-m-d', $endDate)->endOfDay();
            } catch (\Exception $e) {
                return response()->json([
                    'success' => false,
                    'message' => 'Format tanggal tidak valid. Gunakan format YYYY-MM-DD',
                ], Response::HTTP_BAD_REQUEST);
            }

            // Validate date range
            if ($start->isAfter($end)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tanggal mulai harus sebelum tanggal akhir',
                ], Response::HTTP_BAD_REQUEST);
            }

            // Get distribution data grouped by date
            $distribusi = DistribusiBansos::whereBetween('diterima_pada', [$start, $end])
                ->where('status', 'diterima')
                ->select(DB::raw('DATE(diterima_pada) as tanggal'), DB::raw('COUNT(*) as jumlah'))
                ->groupBy(DB::raw('DATE(diterima_pada)'))
                ->orderBy('tanggal', 'asc')
                ->get();

            // Generate date range for the chart (fill missing dates with 0)
            $dateRange = [];
            $current = $start->clone();
            while ($current->lte($end)) {
                $dateStr = $current->format('Y-m-d');
                $found = $distribusi->firstWhere('tanggal', $dateStr);

                $dateRange[] = [
                    'label' => $current->format('d M Y'),
                    'value' => $found ? (int) $found->jumlah : 0,
                ];

                $current->addDay();
            }

            Log::info('Data distribusi berdasarkan tanggal berhasil diambil', [
                'user_id' => auth()->id(),
                'start_date' => $startDate,
                'end_date' => $endDate,
                'count' => count($dateRange),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Data distribusi berhasil diambil',
                'data' => $dateRange,
                'summary' => [
                    'total_distribusi' => collect($dateRange)->sum('value'),
                    'tanggal_mulai' => $start->format('Y-m-d'),
                    'tanggal_akhir' => $end->format('Y-m-d'),
                ],
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil data distribusi berdasarkan tanggal', [
                'user_id' => auth()->id(),
                'start_date' => $request->input('start_date') ?? null,
                'end_date' => $request->input('end_date') ?? null,
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
