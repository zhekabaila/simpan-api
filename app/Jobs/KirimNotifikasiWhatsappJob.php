<?php

namespace App\Jobs;

use App\Services\EvolutionApiService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use Throwable;

class KirimNotifikasiWhatsappJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $tries = 3;

    public function __construct(
        public string $notifikasiId,
        public string $nomorTelepon,
        public string $pesan,
    ) {}

    public function backoff(): array
    {
        return [10, 30, 60];
    }

    public function handle(EvolutionApiService $evolutionApiService): void
    {
        try {
            $evolutionApiService->sendText($this->nomorTelepon, $this->pesan);

            Log::info('KirimNotifikasiWhatsappJob berhasil', [
                'notifikasi_id' => $this->notifikasiId,
            ]);
        } catch (\Exception $e) {
            Log::error('KirimNotifikasiWhatsappJob gagal pada attempt', [
                'notifikasi_id' => $this->notifikasiId,
                'nomor'         => $this->nomorTelepon,
                'attempt'       => $this->attempts(),
                'error'         => $e->getMessage(),
            ]);
            throw $e;
        }
    }

    public function failed(Throwable $exception): void
    {
        Log::error('KirimNotifikasiWhatsappJob FINAL FAILURE semua attempt habis', [
            'notifikasi_id' => $this->notifikasiId,
            'nomor'         => $this->nomorTelepon,
            'error'         => $exception->getMessage(),
        ]);
    }
}
