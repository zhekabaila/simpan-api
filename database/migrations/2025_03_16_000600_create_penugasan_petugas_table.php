<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('penugasan_petugas', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('periode_bansos_id');
            $table->uuid('petugas_id');
            $table->uuid('ditugaskan_oleh');
            $table->text('catatan')->nullable();
            $table->timestamp('ditugaskan_pada')->useCurrent();
            $table->timestamp('updated_at')->nullable();

            $table->foreign('periode_bansos_id')->references('id')->on('periode_bansos')->cascadeOnDelete();
            $table->foreign('petugas_id')->references('id')->on('users')->restrictOnDelete();
            $table->foreign('ditugaskan_oleh')->references('id')->on('users')->restrictOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('penugasan_petugas');
    }
};
