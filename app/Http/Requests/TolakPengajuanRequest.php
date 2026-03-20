<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class TolakPengajuanRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'catatan_admin' => 'required|string|min:10',
        ];
    }

    public function messages(): array
    {
        return [
            'catatan_admin.required' => 'Catatan penolakan harus diisi',
            'catatan_admin.min' => 'Catatan penolakan minimal 10 karakter',
        ];
    }
}
