<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class PenugasanPetugasRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'petugas_id' => 'required|uuid|exists:users,id',
            'periode_bansos_id' => 'required|uuid|exists:periode_bansos,id',
            'catatan' => 'nullable|string',
        ];
    }

    public function messages(): array
    {
        return [
            'petugas_id.required' => 'Petugas harus dipilih',
            'petugas_id.exists' => 'Petugas tidak ditemukan',
            'periode_bansos_id.required' => 'Periode bansos harus dipilih',
            'periode_bansos_id.exists' => 'Periode bansos tidak ditemukan',
        ];
    }
}
