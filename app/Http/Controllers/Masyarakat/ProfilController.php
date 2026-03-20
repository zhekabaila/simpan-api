<?php

namespace App\Http\Controllers\Masyarakat;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Requests\FotoRumahRequest;
use App\Http\Requests\ProfilMasyarakatRequest;
use App\Http\Resources\FotoRumahResource;
use App\Http\Resources\ProfilMasyarakatResource;
use App\Models\FotoRumah;
use App\Models\ProfilMasyarakat;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ProfilController extends Controller
{
    public function getProfile(Request $request)
    {
        try {
            $user = auth()->user();
            $profil = ProfilMasyarakat::where('user_id', $user->id)->with('fotoRumah')->first();

            if (!$profil) {
                return response()->json([
                    'success' => true,
                    'message' => 'Profil belum dibuat',
                    'data' => null,
                ]);
            }

            Log::info('Profil masyarakat berhasil diambil', [
                'user_id' => $user->id,
                'profil_id' => $profil->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Profil berhasil diambil',
                'data' => new ProfilMasyarakatResource($profil),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil profil', [
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

    public function createOrUpdateProfile(ProfilMasyarakatRequest $request)
    {
        try {
            $user = auth()->user();
            $profil = ProfilMasyarakat::updateOrCreate(
                ['user_id' => $user->id],
                $request->validated()
            );

            Log::info('Profil masyarakat berhasil disimpan', [
                'user_id' => $user->id,
                'profil_id' => $profil->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Profil berhasil disimpan',
                'data' => new ProfilMasyarakatResource($profil),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menyimpan profil', [
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

    public function uploadFoto(FotoRumahRequest $request)
    {
        try {
            $user = auth()->user();
            $profil = ProfilMasyarakat::where('user_id', $user->id)->first();

            if (!$profil) {
                return response()->json([
                    'success' => false,
                    'message' => 'Profil tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            // Store file
            $storagePath = "foto-rumah/{$profil->id}";
            if (!Storage::disk('public')->exists($storagePath)) {
                Storage::disk('public')->makeDirectory($storagePath);
            }

            $filename = $request->jenis_foto . '_' . now()->timestamp . '.' . $request->file('foto')->getClientOriginalExtension();
            $fullPath = $storagePath . '/' . $filename;
            Storage::disk('public')->putFileAs($storagePath, $request->file('foto'), $filename);

            // Create database record with full URL
            $fullUrl = Storage::disk('public')->url($fullPath);
            $foto = FotoRumah::create([
                'id' => (string) Str::uuid(),
                'profil_masyarakat_id' => $profil->id,
                'jenis_foto' => $request->jenis_foto,
                'path_foto' => $fullUrl,
                'keterangan' => $request->keterangan,
            ]);

            Log::info('Foto rumah berhasil diunggah', [
                'user_id' => $user->id,
                'profil_id' => $profil->id,
                'foto_id' => $foto->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Foto berhasil diunggah',
                'data' => new FotoRumahResource($foto),
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            Log::error('Gagal mengunggah foto', [
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

    public function deleteFoto($id)
    {
        try {
            $user = auth()->user();
            $profil = ProfilMasyarakat::where('user_id', $user->id)->first();

            if (!$profil) {
                return response()->json([
                    'success' => false,
                    'message' => 'Profil tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            $foto = FotoRumah::where('id', $id)->where('profil_masyarakat_id', $profil->id)->first();

            if (!$foto) {
                return response()->json([
                    'success' => false,
                    'message' => 'Foto tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            // Delete file
            if ($foto->path_foto && Storage::disk('public')->exists($foto->path_foto)) {
                Storage::disk('public')->delete($foto->path_foto);
            }

            $foto->delete();

            Log::info('Foto rumah berhasil dihapus', [
                'user_id' => $user->id,
                'foto_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Foto berhasil dihapus',
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menghapus foto', [
                'user_id' => auth()->id(),
                'foto_id' => $id ?? null,
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

    public function getFotoRumah()
    {
        try {
            $user = auth()->user();
            $profil = ProfilMasyarakat::where('user_id', $user->id)->first();

            if (!$profil) {
                return response()->json([
                    'success' => true,
                    'message' => 'Profil tidak ditemukan',
                    'data' => [],
                ]);
            }

            $fotoRumah = FotoRumah::where('profil_masyarakat_id', $profil->id)->get();

            Log::info('Foto rumah berhasil diambil', [
                'user_id' => $user->id,
                'profil_id' => $profil->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Foto rumah berhasil diambil',
                'data' => FotoRumahResource::collection($fotoRumah),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil foto rumah', [
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
