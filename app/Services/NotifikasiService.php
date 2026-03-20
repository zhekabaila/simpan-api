<?php

namespace App\Services;

use App\Jobs\KirimNotifikasiWhatsappJob;
use App\Models\Notifikasi;
use App\Models\ProfilMasyarakat;
use Illuminate\Support\Facades\Log;

class NotifikasiService
{
    public function kirim(
        string $userId,
        string $judul,
        string $pesan,
        string $jenis,
        ?string $referensiId = null,
        ?string $jenisReferensi = null
    ): Notifikasi {
        try {
            // Save notification to database
            $notifikasi = Notifikasi::create([
                'user_id' => $userId,
                'judul' => $judul,
                'pesan' => $pesan,
                'jenis' => $jenis,
                'referensi_id' => $referensiId,
                'jenis_referensi' => $jenisReferensi,
                'sudah_dibaca' => false,
            ]);

            // Try to get phone number and dispatch job
            try {
                $profil = ProfilMasyarakat::where('user_id', $userId)->first();

                if ($profil && $profil->nomor_telepon) {
                    KirimNotifikasiWhatsappJob::dispatch(
                        $notifikasi->id,
                        $profil->nomor_telepon,
                        $pesan
                    );
                }
            } catch (\Exception $e) {
                Log::error('NotifikasiService gagal dispatch WhatsApp job', [
                    'user_id' => $userId,
                    'notifikasi_id' => $notifikasi->id,
                    'error' => $e->getMessage(),
                ]);
                // Don't throw — job dispatch failure should not crash main flow
            }

            return $notifikasi;
        } catch (\Exception $e) {
            Log::error('NotifikasiService gagal kirim notifikasi', [
                'user_id' => $userId,
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            throw $e;
        }
    }
}
