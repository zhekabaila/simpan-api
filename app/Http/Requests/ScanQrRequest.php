<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ScanQrRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'token_qr' => 'required|string|exists:qrcode_penerima,token_qr',
            'periode_bansos_id' => 'required|uuid|exists:periode_bansos,id',
            'latitude_scan' => 'nullable|numeric|between:-90,90',
            'longitude_scan' => 'nullable|numeric|between:-180,180',
        ];
    }

    public function messages(): array
    {
        return [
            'token_qr.required' => 'Token QR harus diisi',
            'token_qr.exists' => 'Token QR tidak valid',
            'periode_bansos_id.required' => 'Periode bansos harus diisi',
            'periode_bansos_id.exists' => 'Periode bansos tidak ditemukan',
            'latitude_scan.numeric' => 'Latitude harus berupa angka',
            'longitude_scan.numeric' => 'Longitude harus berupa angka',
        ];
    }
}
