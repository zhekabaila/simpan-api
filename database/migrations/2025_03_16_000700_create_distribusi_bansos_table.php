<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('distribusi_bansos', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('periode_bansos_id');
            $table->uuid('profil_masyarakat_id');
            $table->uuid('petugas_id');
            $table->uuid('penugasan_id')->nullable();
            $table->string('token_qr_dipindai');
            $table->enum('status', ['diterima', 'gagal', 'duplikat'])->default('diterima');
            $table->text('alasan_gagal')->nullable();
            $table->decimal('latitude_scan', 10, 8)->nullable();
            $table->decimal('longitude_scan', 11, 8)->nullable();
            $table->timestamp('diterima_pada')->useCurrent();

            $table->foreign('periode_bansos_id')->references('id')->on('periode_bansos')->cascadeOnDelete();
            $table->foreign('profil_masyarakat_id')->references('id')->on('profil_masyarakat')->cascadeOnDelete();
            $table->foreign('petugas_id')->references('id')->on('users')->restrictOnDelete();
            $table->foreign('penugasan_id')->references('id')->on('penugasan_petugas')->nullableOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('distribusi_bansos');
    }
};
