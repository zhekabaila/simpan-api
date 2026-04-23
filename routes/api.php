<?php

use App\Http\Controllers\Admin\MonitoringController;
use App\Http\Controllers\Admin\NotifikasiAdminController;
use App\Http\Controllers\Admin\PengajuanAdminController;
use App\Http\Controllers\Admin\PenggunaAdminController;
use App\Http\Controllers\Admin\PenugasanAdminController;
use App\Http\Controllers\Admin\PeriodeBansosController;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Masyarakat\NotifikasiController;
use App\Http\Controllers\Masyarakat\PengajuanController;
use App\Http\Controllers\Masyarakat\ProfilController;
use App\Http\Controllers\Masyarakat\QrCodeController;
use App\Http\Controllers\Petugas\PetugasController;
use App\Http\Controllers\StorageController;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register'])->name('register');
    Route::post('login', [AuthController::class, 'login'])->name('login');
    Route::post('logout', [AuthController::class, 'logout'])->middleware('auth:api');
    Route::post('refresh', [AuthController::class, 'refresh'])->middleware('auth:api');
    Route::get('me', [AuthController::class, 'me'])->middleware('auth:api');
});

// Protected routes with auth:api middleware
Route::middleware(['auth:api'])->group(function () {
    // Masyarakat routes
    Route::prefix('masyarakat')->middleware(['role:masyarakat'])->group(function () {
        // Profil
        Route::get('profil', [ProfilController::class, 'getProfile']);
        Route::post('profil', [ProfilController::class, 'createOrUpdateProfile']);

        // Foto Rumah
        Route::post('profil/foto-rumah', [ProfilController::class, 'uploadFoto']);
        Route::delete('profil/foto-rumah/{id}', [ProfilController::class, 'deleteFoto']);
        Route::get('profil/foto-rumah', [ProfilController::class, 'getFotoRumah']);

        // Distribusi Bansos
        Route::get('distribusi', [ProfilController::class, 'getRiwayatDistribusi']);

        // Pengajuan
        Route::post('pengajuan', [PengajuanController::class, 'submit']);
        Route::get('pengajuan', [PengajuanController::class, 'getStatus']);

        // QR Code
        Route::get('qrcode', [QrCodeController::class, 'getQrCode']);

        // Notifikasi
        Route::get('notifikasi', [NotifikasiController::class, 'list']);
        Route::patch('notifikasi/{id}/baca', [NotifikasiController::class, 'markAsRead']);
        Route::patch('notifikasi/baca-semua', [NotifikasiController::class, 'markAllAsRead']);
    });

    // Petugas routes
    Route::prefix('petugas')->middleware(['role:petugas'])->group(function () {
        Route::get('profil', [PetugasController::class, 'getProfile']);
        Route::post('profil', [PetugasController::class, 'updateProfile']);
        Route::get('penugasan', [PetugasController::class, 'getPenugasan']);
        Route::get('penugasan/{id}', [PetugasController::class, 'detailPenugasan']);
        Route::post('scan-qr', [PetugasController::class, 'scanQr']);
        Route::get('riwayat-distribusi', [PetugasController::class, 'riwayatDistribusi']);
        Route::get('list-masyarakat/{periode_id}', [MonitoringController::class, 'peta']);

        // Dokumentasi Distribusi
        Route::post('dokumentasi', [PetugasController::class, 'uploadDokumentasi']);
        Route::get('dokumentasi/{id}', [PetugasController::class, 'getDokumentasi']);
        Route::get('dokumentasi-periode/{periode_id}', [PetugasController::class, 'getDokumentasiByPeriode']);
        Route::delete('dokumentasi/{id}', [PetugasController::class, 'deleteDokumentasi']);
    });

    // Admin routes
    Route::prefix('admin')->middleware(['role:admin'])->group(function () {
        // Pengajuan
        Route::get('pengajuan', [PengajuanAdminController::class, 'list']);
        Route::get('pengajuan/{id}', [PengajuanAdminController::class, 'detail']);
        Route::patch('pengajuan/{id}/setujui', [PengajuanAdminController::class, 'approve']);
        Route::patch('pengajuan/{id}/tinjau', [PengajuanAdminController::class, 'review']);
        Route::patch('pengajuan/{id}/tolak', [PengajuanAdminController::class, 'reject']);

        // Periode Bansos
        Route::get('periode-bansos', [PeriodeBansosController::class, 'list']);
        Route::post('periode-bansos', [PeriodeBansosController::class, 'create']);
        Route::get('periode-bansos/{id}', [PeriodeBansosController::class, 'detail']);
        Route::patch('periode-bansos/{id}', [PeriodeBansosController::class, 'update']);
        Route::delete('periode-bansos/{id}', [PeriodeBansosController::class, 'delete']);

        // Penugasan Petugas
        Route::get('penugasan', [PenugasanAdminController::class, 'list']);
        Route::post('penugasan', [PenugasanAdminController::class, 'create']);
        Route::get('penugasan/{id}', [PenugasanAdminController::class, 'detail']);
        Route::patch('penugasan/{id}', [PenugasanAdminController::class, 'update']);
        Route::delete('penugasan/{id}', [PenugasanAdminController::class, 'delete']);
        Route::get('dokumentasi-periode/{periode_id}', [PetugasController::class, 'getDokumentasiByPeriodeAdmin']);

        // Monitoring
        Route::get('monitoring/statistik', [MonitoringController::class, 'statistik']);
        Route::get('monitoring/distribusi/{periode_id}', [MonitoringController::class, 'distribusi']);
        Route::get('monitoring/distribusi-by-date', [MonitoringController::class, 'distribusiByDate']);
        Route::get('monitoring/peta/{periode_id}', [MonitoringController::class, 'peta']);

        // Notifikasi
        Route::get('notifikasi', [NotifikasiAdminController::class, 'list']);
        Route::post('notifikasi/kirim', [NotifikasiAdminController::class, 'send']);

        // Pengguna
        Route::get('pengguna', [PenggunaAdminController::class, 'list']);
        Route::post('pengguna/registrasi-by-admin', [PenggunaAdminController::class, 'createUserWithProfile']);
        Route::post('pengguna/buat-petugas', [PenggunaAdminController::class, 'createPetugasUser']);
        Route::patch('pengguna/{id}/reset-password', [PenggunaAdminController::class, 'resetUserPassword']);
        Route::get('pengguna/{id}', [PenggunaAdminController::class, 'detail']);
        Route::patch('pengguna/{id}/toggle-aktif', [PenggunaAdminController::class, 'toggleAktif']);
    });

    // File serving routes
    Route::get('storage/foto-rumah/{profil_id}/{filename}', [StorageController::class, 'serveFotoRumah']);
    Route::get('storage/qrcode/{profil_id}/{filename}', [StorageController::class, 'serveQrCode']);
});
