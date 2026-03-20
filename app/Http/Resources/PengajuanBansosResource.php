<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PengajuanBansosResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'profil_masyarakat_id' => $this->profil_masyarakat_id,
            'nomor_pengajuan' => $this->nomor_pengajuan,
            'status' => $this->status,
            'catatan_admin' => $this->catatan_admin,
            'ditinjau_oleh' => $this->ditinjau_oleh,
            'ditinjau_pada' => $this->ditinjau_pada,
            'diajukan_pada' => $this->diajukan_pada,
            'profil' => new ProfilMasyarakatResource($this->profilMasyarakat),
            'reviewer' => $this->ditinjauOleh ? new UserResource($this->ditinjauOleh) : null,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
