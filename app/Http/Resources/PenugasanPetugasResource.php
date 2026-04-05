<?php

namespace App\Http\Resources;

use App\Models\User;
use App\Models\DistribusiBansos;
use App\Models\PengajuanBansos;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Cache;

class PenugasanPetugasResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        // 1. Ambil Total Penerima (Hanya masyarakat dengan status pengajuan 'disetujui')
        // Kita gunakan cache selama 10 menit agar tidak membebani database
        $totalPenerima = Cache::remember('total_approved_applicants_count', 600, function () {
            return PengajuanBansos::where('status', 'disetujui')
                ->distinct('profil_masyarakat_id')
                ->count();
        });
        // 2. Ambil Jumlah yang Sudah Terima pada periode penugasan ini
        $sudahTerima = DistribusiBansos::where('periode_bansos_id', $this->periode_bansos_id)
            ->where('status', 'diterima')
            ->count();
        // 3. Kalkulasi sisanya
        $belumTerima = max(0, $totalPenerima - $sudahTerima);
        $progress = $totalPenerima > 0 ? round(($sudahTerima / $totalPenerima) * 100, 2) : 0;
        
        return [
            'id' => $this->id,
            'periode_bansos_id' => $this->periode_bansos_id,
            'petugas_id' => $this->petugas_id,
            'ditugaskan_oleh' => $this->ditugaskan_oleh,
            'catatan' => $this->catatan,
            'ditugaskan_pada' => $this->ditugaskan_pada,
            'updated_at' => $this->updated_at,
            'petugas' => new UserResource($this->petugas),
            'periode' => new PeriodeBansosResource($this->periodeBansos),
            'statistik' => [
                'total_penerima' => $totalPenerima,
                'sudah_terima' => $sudahTerima,
                'belum_terima' => $belumTerima,
                'progress_distribusi' => $progress . '%'
            ]
        ];
    }
}
