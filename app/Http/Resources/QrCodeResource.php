<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class QrCodeResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'token_qr' => $this->token_qr,
            'url_gambar_qr' => $this->path_gambar_qr ? Storage::disk('public')->url($this->path_gambar_qr) : null,
            'aktif' => $this->aktif,
            'created_at' => $this->created_at,
            'kedaluwarsa_pada' => $this->kedaluwarsa_pada,
        ];
    }
}
