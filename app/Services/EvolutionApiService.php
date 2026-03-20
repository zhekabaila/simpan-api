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
}
