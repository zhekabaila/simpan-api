<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('dokumentasi_distribusi', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('periode_bansos_id');
            $table->uuid('petugas_id');
            $table->enum('jenis_dokumentasi', ['foto', 'catatan']);
            $table->string('path_dokumentasi'); // URL foto
            $table->text('keterangan')->nullable();
            $table->timestamp('diunggah_pada')->useCurrent();

            $table->foreign('periode_bansos_id')->references('id')->on('periode_bansos')->cascadeOnDelete();
            $table->foreign('petugas_id')->references('id')->on('users')->restrictOnDelete();

            $table->index('periode_bansos_id');
            $table->index('petugas_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('dokumentasi_distribusi');
    }
};
