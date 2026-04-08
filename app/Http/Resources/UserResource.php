<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $data = [
            'id' => $this->id,
            'nama' => $this->nama,
            'email' => $this->email,
            'aktif' => $this->aktif,
            'role' => $this->role,
            'created_at' => $this->created_at,
        ];

        // Include profil_masyarakat if user is masyarakat
        if ($this->role === 'masyarakat' && $this->profilMasyarakat) {
            $data['profil'] = [
                'id' => $this->profilMasyarakat->id,
                'nik' => $this->profilMasyarakat->nik,
                'alamat' => $this->profilMasyarakat->alamat,
                'rt_rw' => $this->profilMasyarakat->rt_rw,
                'jumlah_anggota_keluarga' => $this->profilMasyarakat->jumlah_anggota_keluarga,
                'penghasilan_bulanan' => $this->profilMasyarakat->penghasilan_bulanan,
                'status_rumah' => $this->profilMasyarakat->status_rumah,
                'created_at' => $this->profilMasyarakat->created_at,
                'updated_at' => $this->profilMasyarakat->updated_at,
            ];
        }

        // Include profil_petugas if user is petugas
        if ($this->role === 'petugas' && $this->profilPetugas) {
            $data['profil'] = [
                'id' => $this->profilPetugas->id,
                'nomor_telepon' => $this->profilPetugas->nomor_telepon,
                'alamat' => $this->profilPetugas->alamat,
                'latitude' => $this->profilPetugas->latitude,
                'longitude' => $this->profilPetugas->longitude,
                'created_at' => $this->profilPetugas->created_at,
                'updated_at' => $this->profilPetugas->updated_at,
            ];
        }

        return $data;
    }
}
