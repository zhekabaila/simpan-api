<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class FotoRumahResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'jenis_foto' => $this->jenis_foto,
            'url_foto' => $this->path_foto,
            'keterangan' => $this->keterangan,
            'diunggah_pada' => $this->diunggah_pada,
        ];
    }
}
