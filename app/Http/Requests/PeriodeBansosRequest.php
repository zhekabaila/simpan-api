<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class PeriodeBansosRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'nama_periode' => 'required|string',
            'jenis_bantuan' => 'required|in:sembako,tunai,bpnt,pkh,lainnya',
            'deskripsi' => 'nullable|string',
            'status' => 'nullable|in:akan_datang,aktif,selesai',
        ];
    }

    public function messages(): array
    {
        return [
            'nama_periode.required' => 'Nama periode harus diisi',
            'jenis_bantuan.required' => 'Jenis bantuan harus dipilih',
        ];
    }
}
