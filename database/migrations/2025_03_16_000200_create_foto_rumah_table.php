<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('foto_rumah', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('profil_masyarakat_id');
            $table->enum('jenis_foto', ['tampak_depan', 'ruang_tamu', 'kamar_tidur', 'kamar_mandi', 'dapur', 'atap_dinding', 'sumber_air', 'jamban']);
            $table->string('path_foto');
            $table->text('keterangan')->nullable();
            $table->timestamp('diunggah_pada')->useCurrent();

            $table->foreign('profil_masyarakat_id')->references('id')->on('profil_masyarakat')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('foto_rumah');
    }
};
