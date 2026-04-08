<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class EvolutionApiService
{
    public function sendText(string $nomorTelepon, string $pesan): bool
    {
        try {
            $url = config('services.evolution.url')
                . '/message/sendText/'
                . config('services.evolution.instance');

            $response = Http::withHeaders([
                'Content-Type' => 'application/json',
                'apikey'       => config('services.evolution.key'),
            ])->post($url, [
                'number' => $nomorTelepon,
                'text'   => $pesan,
            ]);

            if ($response->successful()) {
                Log::info('EvolutionApiService berhasil kirim pesan', [
                    'nomor'  => $nomorTelepon,
                    'status' => $response->status(),
                ]);
                return true;
            }

            Log::error('EvolutionApiService response gagal', [
                'nomor'  => $nomorTelepon,
                'status' => $response->status(),
                'body'   => $response->body(),
            ]);
            return false;
        } catch (\Exception $e) {
            Log::error('EvolutionApiService exception', [
                'nomor' => $nomorTelepon,
                'error' => $e->getMessage(),
                'file'  => $e->getFile(),
                'line'  => $e->getLine(),
            ]);
            return false;
        }
    }

    public function checkWhatsAppNumber(string $nomorTelepon): bool
    {
        try {
            $url = config('services.evolution.url')
                . '/chat/whatsappNumbers/'
                . config('services.evolution.instance');

            $response = Http::withHeaders([
                'Content-Type' => 'application/json',
                'apikey'       => config('services.evolution.key'),
            ])->post($url, [
                'numbers' => [$nomorTelepon],
            ]);

            if ($response->successful()) {
                $data = $response->json();

                // Check if response is array and has at least one element
                if (is_array($data) && count($data) > 0) {
                    $result = $data[0];

                    Log::info('EvolutionApiService verifikasi nomor WA', [
                        'nomor'  => $nomorTelepon,
                        'exists' => $result['exists'] ?? false,
                    ]);

                    return $result['exists'] ?? false;
                }

                Log::warning('EvolutionApiService response kosong', [
                    'nomor' => $nomorTelepon,
                    'body'  => $response->body(),
                ]);
                return false;
            }

            Log::error('EvolutionApiService verifikasi gagal', [
                'nomor'  => $nomorTelepon,
                'status' => $response->status(),
                'body'   => $response->body(),
            ]);
            return false;
        } catch (\Exception $e) {
            Log::error('EvolutionApiService checkWhatsAppNumber exception', [
                'nomor' => $nomorTelepon,
                'error' => $e->getMessage(),
                'file'  => $e->getFile(),
                'line'  => $e->getLine(),
            ]);
            return false;
        }
    }
}
