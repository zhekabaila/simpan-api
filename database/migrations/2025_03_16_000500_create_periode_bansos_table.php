<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('periode_bansos', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('nama_periode');
            $table->enum('jenis_bantuan', ['sembako', 'tunai', 'bpnt', 'pkh', 'lainnya']);
            $table->text('deskripsi')->nullable();
            $table->date('tanggal_mulai');
            $table->date('tanggal_selesai');
            $table->enum('status', ['akan_datang', 'aktif', 'selesai'])->default('akan_datang');
            $table->uuid('dibuat_oleh');
            $table->timestamps();

            $table->foreign('dibuat_oleh')->references('id')->on('users')->restrictOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('periode_bansos');
    }
};
