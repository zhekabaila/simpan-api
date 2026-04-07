<?php

namespace App\Services;

use App\Jobs\KirimNotifikasiWhatsappJob;
use App\Models\Notifikasi;
use App\Models\ProfilMasyarakat;
use Illuminate\Support\Facades\Log;

class NotifikasiService
{
    /**
     * Strip WhatsApp formatting from message before saving to database
     * Removes: *bold*, _italic_, ~strikethrough~, `code`, *bold code*, and newlines for clean storage
     */
    private function stripMessageFormatter(string $message): string
    {
        // Remove markdown formatting but keep content
        $clean = preg_replace('/\*([^*]+)\*/u', '$1', $message); // Remove *bold*
        $clean = preg_replace('/_([^_]+)_/u', '$1', $clean); // Remove _italic_
        $clean = preg_replace('/~([^~]+)~/u', '$1', $clean); // Remove ~strikethrough~
        $clean = preg_replace('/`([^`]+)`/u', '$1', $clean); // Remove `code`
        
        return $clean;
    }

    public function kirim(
        string $userId,
        string $judul,
        string $pesan,
        string $jenis,
        ?string $referensiId = null,
        ?string $jenisReferensi = null
    ): Notifikasi {
        try {
            // Strip formatter for database storage
            $pesanBersih = $this->stripMessageFormatter($pesan);

            // Save notification to database
            $notifikasi = Notifikasi::create([
                'user_id' => $userId,
                'judul' => $judul,
                'pesan' => $pesanBersih,
                'jenis' => $jenis,
                'referensi_id' => $referensiId,
                'jenis_referensi' => $jenisReferensi,
                'sudah_dibaca' => false,
            ]);

            // Try to get phone number and dispatch job with formatted message for WhatsApp
            try {
                $profil = ProfilMasyarakat::where('user_id', $userId)->first();

                if ($profil && $profil->nomor_telepon) {
                    // Send formatted message to WhatsApp
                    KirimNotifikasiWhatsappJob::dispatch(
                        $notifikasi->id,
                        $profil->nomor_telepon,
                        $pesan // Original message with formatting for WhatsApp
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
