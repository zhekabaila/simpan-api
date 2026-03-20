<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class FotoRumahRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'jenis_foto' => 'required|in:tampak_depan,ruang_tamu,kamar_tidur,kamar_mandi,dapur,atap_dinding,sumber_air,jamban',
            'foto' => 'required|file|mimes:jpeg,jpg,png|max:2048',
            'keterangan' => 'nullable|string',
        ];
    }

    public function messages(): array
    {
        return [
            'jenis_foto.required' => 'Jenis foto harus dipilih',
            'jenis_foto.in' => 'Jenis foto tidak valid',
            'foto.required' => 'Foto harus diunggah',
            'foto.file' => 'File harus berupa file',
            'foto.mimes' => 'Format foto harus jpeg, jpg, atau png',
            'foto.max' => 'Ukuran foto maksimal 2MB',
        ];
    }
}
