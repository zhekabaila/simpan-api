<?php

namespace App\Http\Resources;

use App\Models\DistribusiBansos;
use App\Models\PengajuanBansos;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Cache;

class PeriodeBansosResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        // 1. Ambil Total Penerima (Hanya masyarakat dengan status pengajuan 'disetujui')
        $totalPenerima = Cache::remember('total_approved_applicants_count', 600, function () {
            return PengajuanBansos::where('status', 'disetujui')
                ->distinct('profil_masyarakat_id')
                ->count();
        });

        // 2. Ambil Jumlah yang Sudah Terima pada periode ini
        $sudahTerima = DistribusiBansos::where('periode_bansos_id', $this->id)
            ->where('status', 'diterima')
            ->count();

        // 3. Kalkulasi sisanya
        $belumTerima = max(0, $totalPenerima - $sudahTerima);
        $progress = $totalPenerima > 0 ? round(($sudahTerima / $totalPenerima) * 100, 2) : 0;

        return [
            'id' => $this->id,
            'nama_periode' => $this->nama_periode,
            'jenis_bantuan' => $this->jenis_bantuan,
            'deskripsi' => $this->deskripsi,
            'status' => $this->status,
            'dibuat_oleh' => $this->dibuat_oleh,
            'pembuat' => new UserResource($this->pembuatPeriode),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'statistik' => [
                'total_penerima' => $totalPenerima,
                'sudah_terima' => $sudahTerima,
                'belum_terima' => $belumTerima,
                'progress_distribusi' => $progress . '%'
            ]
        ];
    }
}
