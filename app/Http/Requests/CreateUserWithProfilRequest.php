<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CreateUserWithProfilRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            // User data
            'nama' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8',
            'role' => 'nullable|in:masyarakat,petugas,admin',

            // Profil Masyarakat data
            'nik' => 'required|digits:16|unique:profil_masyarakat',
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
            // User messages
            'nama.required' => 'Nama harus diisi',
            'nama.string' => 'Nama harus berupa teks',
            'email.required' => 'Email harus diisi',
            'email.email' => 'Email tidak valid',
            'email.unique' => 'Email sudah terdaftar',
            'password.required' => 'Password harus diisi',
            'password.min' => 'Password minimal 8 karakter',
            'role.in' => 'Role harus salah satu dari: masyarakat, petugas, admin',

            // Profil Masyarakat messages
            'nik.required' => 'NIK harus diisi',
            'nik.digits' => 'NIK harus 16 digit',
            'nik.unique' => 'NIK sudah terdaftar',
            'nomor_telepon.required' => 'Nomor telepon harus diisi',
            'nomor_telepon.numeric' => 'Nomor telepon harus berupa angka',
            'nomor_telepon.digits_between' => 'Nomor telepon harus 10-15 digit',
            'latitude.numeric' => 'Latitude harus berupa angka',
            'latitude.between' => 'Latitude harus antara -90 dan 90',
            'longitude.numeric' => 'Longitude harus berupa angka',
            'longitude.between' => 'Longitude harus antara -180 dan 180',
        ];
    }
}
