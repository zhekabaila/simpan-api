<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProfilMasyarakatRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'nik' => 'required|digits:16|unique:profil_masyarakat,nik,' . auth()->id() . ',user_id',
            'nama' => 'required|string',
            'nomor_telepon' => 'required|numeric|digits_between:10,15',
            'tanggal_lahir' => 'nullable|date',
            'jenis_kelamin' => 'nullable|in:L,P',
            'alamat' => 'nullable|string',
            'rt' => 'nullable|string|max:5',
            'rw' => 'nullable|string|max:5',
            'kelurahan' => 'nullable|string',
            'kecamatan' => 'nullable|string',
            'kota' => 'nullable|string',
            'provinsi' => 'nullable|string',
            'latitude' => 'nullable|numeric|between:-90,90',
            'longitude' => 'nullable|numeric|between:-180,180',
            'status_pernikahan' => 'nullable|in:belum_menikah,menikah,cerai_hidup,cerai_mati',
            'jumlah_tanggungan' => 'nullable|integer|min:0',
            'status_pekerjaan' => 'nullable|in:bekerja,tidak_bekerja,wiraswasta,pensiun',
            'penghasilan_bulanan' => 'nullable|integer|min:0',
            'status_kepemilikan_rumah' => 'nullable|in:milik_sendiri,kontrak,numpang,lainnya',
        ];
    }

    public function messages(): array
    {
        return [
            'nik.required' => 'NIK harus diisi',
            'nik.digits' => 'NIK harus 16 digit',
            'nik.unique' => 'NIK sudah terdaftar',
            'nama.required' => 'Nama harus diisi',
            'nomor_telepon.required' => 'Nomor telepon harus diisi',
            'nomor_telepon.numeric' => 'Nomor telepon harus berupa angka',
            'nomor_telepon.digits_between' => 'Nomor telepon harus 10-15 digit',
            // 'alamat.required' => 'Alamat harus diisi',
            'latitude.numeric' => 'Latitude harus berupa angka',
            'latitude.between' => 'Latitude harus antara -90 dan 90',
            'longitude.numeric' => 'Longitude harus berupa angka',
            'longitude.between' => 'Longitude harus antara -180 dan 180',
        ];
    }
}
