<?php

namespace App\Http\Controllers;

use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class StorageController extends Controller
{
    public function serveFotoRumah($profilMasyarakatId, $filename)
    {
        try {
            $path = "foto-rumah/{$profilMasyarakatId}/{$filename}";

            if (!Storage::disk('local')->exists($path)) {
                Log::warning('File foto rumah tidak ditemukan', [
                    'user_id' => auth()->id(),
                    'path' => $path,
                ]);
                return response()->json([
                    'success' => false,
                    'message' => 'File tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            Log::info('File foto rumah berhasil diakses', [
                'user_id' => auth()->id(),
                'profil_id' => $profilMasyarakatId,
            ]);

            return response()->file(
                Storage::disk('local')->path($path),
                ['Content-Type' => Storage::disk('local')->mimeType($path)]
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengakses file foto rumah', [
                'user_id' => auth()->id(),
                'profil_id' => $profilMasyarakatId ?? null,
                'filename' => $filename ?? null,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function serveQrCode($profilMasyarakatId, $filename)
    {
        try {
            $path = "qrcode/{$profilMasyarakatId}/{$filename}";

            if (!Storage::disk('local')->exists($path)) {
                Log::warning('File QR Code tidak ditemukan', [
                    'user_id' => auth()->id(),
                    'path' => $path,
                ]);
                return response()->json([
                    'success' => false,
                    'message' => 'File tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            Log::info('File QR Code berhasil diakses', [
                'user_id' => auth()->id(),
                'profil_id' => $profilMasyarakatId,
            ]);

            return response()->file(
                Storage::disk('local')->path($path),
                ['Content-Type' => 'image/png']
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengakses file QR Code', [
                'user_id' => auth()->id(),
                'profil_id' => $profilMasyarakatId ?? null,
                'filename' => $filename ?? null,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
