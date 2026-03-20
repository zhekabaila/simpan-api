<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProfilMasyarakatResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'nik' => $this->nik,
            'nama' => $this->nama,
            'nomor_telepon' => $this->nomor_telepon,
            'tanggal_lahir' => $this->tanggal_lahir,
            'jenis_kelamin' => $this->jenis_kelamin,
            'alamat' => $this->alamat,
            'rt' => $this->rt,
            'rw' => $this->rw,
            'kelurahan' => $this->kelurahan,
            'kecamatan' => $this->kecamatan,
            'kota' => $this->kota,
            'provinsi' => $this->provinsi,
            'latitude' => $this->latitude,
            'longitude' => $this->longitude,
            'status_pernikahan' => $this->status_pernikahan,
            'jumlah_tanggungan' => $this->jumlah_tanggungan,
            'status_pekerjaan' => $this->status_pekerjaan,
            'penghasilan_bulanan' => $this->penghasilan_bulanan,
            'status_kepemilikan_rumah' => $this->status_kepemilikan_rumah,
            'foto_rumah' => FotoRumahResource::collection($this->fotoRumah),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
