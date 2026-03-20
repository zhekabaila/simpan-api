<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notifikasi', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->string('judul');
            $table->text('pesan');
            $table->enum('jenis', ['status_pengajuan', 'jadwal_distribusi', 'qr_siap', 'umum']);
            $table->uuid('referensi_id')->nullable();
            $table->string('jenis_referensi')->nullable();
            $table->boolean('sudah_dibaca')->default(false);
            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('dibaca_pada')->nullable();

            $table->foreign('user_id')->references('id')->on('users')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifikasi');
    }
};
