<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class DokumentasiDistribusiRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'periode_bansos_id' => 'required|exists:periode_bansos,id',
            'jenis_dokumentasi' => 'required|in:foto,catatan',
            'foto' => 'required_if:jenis_dokumentasi,foto|nullable|image|mimes:jpeg,png,jpg,gif|max:5120',
            'keterangan' => 'nullable|string|max:500',
        ];
    }

    public function messages(): array
    {
        return [
            'periode_bansos_id.required' => 'Periode bansos harus dipilih',
            'periode_bansos_id.exists' => 'Periode bansos tidak ditemukan',
            'jenis_dokumentasi.required' => 'Jenis dokumentasi harus dipilih',
            'jenis_dokumentasi.in' => 'Jenis dokumentasi harus foto atau catatan',
            'foto.required_if' => 'Foto harus diupload jika jenis dokumentasi adalah foto',
            'foto.image' => 'File harus berupa gambar',
            'foto.mimes' => 'Format gambar harus jpeg, png, jpg, atau gif',
            'foto.max' => 'Ukuran gambar tidak boleh lebih dari 5MB',
            'keterangan.max' => 'Keterangan tidak boleh lebih dari 500 karakter',
        ];
    }
}
