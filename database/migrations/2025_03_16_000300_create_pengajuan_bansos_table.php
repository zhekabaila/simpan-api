<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('pengajuan_bansos', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('profil_masyarakat_id');
            $table->string('nomor_pengajuan')->unique();
            $table->enum('status', ['menunggu', 'ditinjau', 'disetujui', 'ditolak'])->default('menunggu');
            $table->text('catatan_admin')->nullable();
            $table->uuid('ditinjau_oleh')->nullable();
            $table->timestamp('ditinjau_pada')->nullable();
            $table->timestamp('diajukan_pada')->useCurrent();
            $table->timestamps();

            $table->foreign('profil_masyarakat_id')->references('id')->on('profil_masyarakat')->cascadeOnDelete();
            $table->foreign('ditinjau_oleh')->references('id')->on('users')->nullableOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pengajuan_bansos');
    }
};
