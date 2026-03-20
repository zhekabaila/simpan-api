<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('qrcode_penerima', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('profil_masyarakat_id')->unique();
            $table->string('token_qr')->unique();
            $table->string('path_gambar_qr')->nullable();
            $table->boolean('aktif')->default(true);
            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('kedaluwarsa_pada')->nullable();

            $table->foreign('profil_masyarakat_id')->references('id')->on('profil_masyarakat')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('qrcode_penerima');
    }
};
