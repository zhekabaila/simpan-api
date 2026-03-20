<?php

namespace App\Http\Controllers\Masyarakat;

use App\Http\Controllers\Controller;
use App\Http\Resources\QrCodeResource;
use App\Models\ProfilMasyarakat;
use App\Models\QrcodePenerima;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;

class QrCodeController extends Controller
{
    public function getQrCode()
    {
        try {
            $user = auth()->user();
            $profil = ProfilMasyarakat::where('user_id', $user->id)->first();

            if (!$profil) {
                return response()->json([
                    'success' => false,
                    'message' => 'Profil tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            $qrcode = QrcodePenerima::where('profil_masyarakat_id', $profil->id)->first();

            if (!$qrcode) {
                return response()->json([
                    'success' => true,
                    'message' => 'QR Code belum tersedia',
                    'data' => null,
                ]);
            }

            Log::info('QR Code berhasil diambil', [
                'user_id' => $user->id,
                'profil_id' => $profil->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'QR Code berhasil diambil',
                'data' => new QrCodeResource($qrcode),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil QR Code', [
                'user_id' => auth()->id(),
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
