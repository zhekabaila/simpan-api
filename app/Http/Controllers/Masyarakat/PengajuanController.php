<?php

namespace App\Http\Controllers\Masyarakat;

use App\Http\Controllers\Controller;
use App\Http\Requests\PengajuanBansosRequest;
use App\Http\Resources\PengajuanBansosResource;
use App\Models\PengajuanBansos;
use App\Models\ProfilMasyarakat;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class PengajuanController extends Controller
{
    public function submit(PengajuanBansosRequest $request)
    {
        try {
            $user = auth()->user();
            $profil = ProfilMasyarakat::where('user_id', $user->id)->first();

            if (!$profil) {
                return response()->json([
                    'success' => false,
                    'message' => 'Profil tidak ditemukan. Lengkapi profil terlebih dahulu',
                ], Response::HTTP_NOT_FOUND);
            }

            // Validate profile is complete
            $requiredFields = ['nik', 'alamat', 'status_pekerjaan', 'penghasilan_bulanan'];
            foreach ($requiredFields as $field) {
                if (empty($profil->$field)) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Profil belum lengkap. Harap lengkapi semua data yang diperlukan',
                    ], Response::HTTP_BAD_REQUEST);
                }
            }

            // Check if there's an active pengajuan
            $activePengajuan = PengajuanBansos::where('profil_masyarakat_id', $profil->id)
                ->whereIn('status', ['menunggu', 'ditinjau', 'disetujui'])
                ->first();

            if ($activePengajuan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Anda sudah memiliki pengajuan yang sedang diproses',
                ], Response::HTTP_BAD_REQUEST);
            }

            // Create pengajuan
            $pengajuan = PengajuanBansos::create([
                'id' => (string) Str::uuid(),
                'profil_masyarakat_id' => $profil->id,
                'status' => 'menunggu',
            ]);

            Log::info('Pengajuan bansos berhasil diajukan', [
                'user_id' => $user->id,
                'pengajuan_id' => $pengajuan->id,
                'nomor_pengajuan' => $pengajuan->nomor_pengajuan,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pengajuan bansos berhasil diajukan',
                'data' => new PengajuanBansosResource($pengajuan),
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            Log::error('Gagal mengajukan bansos', [
                'user_id' => auth()->id(),
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function getStatus()
    {
        try {
            $user = auth()->user();
            $profil = ProfilMasyarakat::where('user_id', $user->id)->first();

            if (!$profil) {
                return response()->json([
                    'success' => true,
                    'message' => 'Pengajuan tidak ditemukan',
                    'data' => null,
                ]);
            }

            $pengajuan = PengajuanBansos::where('profil_masyarakat_id', $profil->id)
                ->latest()
                ->first();

            if (!$pengajuan) {
                return response()->json([
                    'success' => true,
                    'message' => 'Pengajuan tidak ditemukan',
                    'data' => null,
                ]);
            }

            Log::info('Status pengajuan berhasil diambil', [
                'user_id' => $user->id,
                'pengajuan_id' => $pengajuan->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Status pengajuan berhasil diambil',
                'data' => new PengajuanBansosResource($pengajuan),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil status pengajuan', [
                'user_id' => auth()->id(),
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
