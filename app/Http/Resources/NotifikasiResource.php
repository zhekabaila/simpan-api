<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NotifikasiResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'judul' => $this->judul,
            'pesan' => $this->pesan,
            'jenis' => $this->jenis,
            'referensi_id' => $this->referensi_id,
            'jenis_referensi' => $this->jenis_referensi,
            'sudah_dibaca' => $this->sudah_dibaca,
            'created_at' => $this->created_at,
            'dibaca_pada' => $this->dibaca_pada,
        ];
    }
}
