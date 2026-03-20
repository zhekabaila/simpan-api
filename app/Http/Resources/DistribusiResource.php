<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DistribusiResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $nik = $this->profilMasyarakat->nik;
        $nikMasked = substr($nik, 0, 4) . str_repeat('*', 12);

        return [
            'id' => $this->id,
            'periode_bansos_id' => $this->periode_bansos_id,
            'profil_masyarakat_id' => $this->profil_masyarakat_id,
            'petugas_id' => $this->petugas_id,
            'penugasan_id' => $this->penugasan_id,
            'token_qr_dipindai' => $this->token_qr_dipindai,
            'status' => $this->status,
            'alasan_gagal' => $this->alasan_gagal,
            'latitude_scan' => $this->latitude_scan,
            'longitude_scan' => $this->longitude_scan,
            'diterima_pada' => $this->diterima_pada,
            'profil_masyarakat' => [
                'id' => $this->profilMasyarakat->id,
                'nama' => $this->profilMasyarakat->user->nama ?? null,
                'nik' => $nikMasked,
            ],
            'petugas' => [
                'id' => $this->petugas->id,
                'nama' => $this->petugas->nama,
            ],
        ];
    }
}
