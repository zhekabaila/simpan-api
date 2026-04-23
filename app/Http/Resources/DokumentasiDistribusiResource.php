<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DokumentasiDistribusiResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'periode_bansos_id' => $this->periode_bansos_id,
            'petugas_id' => $this->petugas_id,
            'jenis_dokumentasi' => $this->jenis_dokumentasi,
            'path_dokumentasi' => $this->path_dokumentasi,
            'keterangan' => $this->keterangan,
            'diunggah_pada' => $this->diunggah_pada,
            'periode_bansos' => [
                'id' => $this->periodeBansos->id,
                'nama_periode' => $this->periodeBansos->nama_periode,
                'jenis_bantuan' => $this->periodeBansos->jenis_bantuan,
            ],
            'petugas' => [
                'id' => $this->petugas->id,
                'nama' => $this->petugas->nama,
            ],
        ];
    }
}
