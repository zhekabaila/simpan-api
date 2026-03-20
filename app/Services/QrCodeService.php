<?php

namespace App\Services;

use App\Models\QrcodePenerima;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use SimpleSoftwareIO\QrCode\Facades\QrCode;

class QrCodeService
{
    public function generate(string $profilMasyarakatId): QrcodePenerima
    {
        try {
            $tokenQr = (string) Str::uuid();

            // Generate QR Code image
            $qrCodeContent = QrCode::format('svg')->size(300)->generate($tokenQr);

            // Create storage path
            $storagePath = "qrcode/{$profilMasyarakatId}";
            if (!Storage::disk('public')->exists($storagePath)) {
                Storage::disk('public')->makeDirectory($storagePath);
            }

            // Save QR code image
            $filename = "qr_{$tokenQr}.svg";
            $fullPath = $storagePath . '/' . $filename;
            Storage::disk('public')->put($fullPath, $qrCodeContent);

            // Create database record
            $qrcode = QrcodePenerima::create([
                'profil_masyarakat_id' => $profilMasyarakatId,
                'token_qr' => $tokenQr,
                'path_gambar_qr' => $fullPath,
                'aktif' => true,
            ]);

            Log::info('QrCodeService berhasil generate QR', [
                'profil_id' => $profilMasyarakatId,
                'token_qr' => $tokenQr,
            ]);

            return $qrcode;
        } catch (\Exception $e) {
            Log::error('QrCodeService gagal generate QR', [
                'profil_id' => $profilMasyarakatId,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            throw $e;
        }
    }
}
