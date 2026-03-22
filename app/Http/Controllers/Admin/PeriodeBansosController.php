<?php

namespace App\Http\Controllers\Admin;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Requests\PeriodeBansosRequest;
use App\Http\Resources\PeriodeBansosResource;
use App\Models\PeriodeBansos;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class PeriodeBansosController extends Controller
{
    public function list(Request $request)
    {
        try {
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $paginator = PeriodeBansos::with('pembuatPeriode')
                ->latest('created_at')
                ->paginate($limit, ['*'], 'page', $page);

            Log::info('Daftar periode bansos berhasil diambil', [
                'user_id' => auth()->id(),
                'count' => $paginator->count(),
            ]);

            return response()->json(
                PaginationHelper::format($paginator, PeriodeBansosResource::collection($paginator))
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil daftar periode bansos', [
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

    public function create(PeriodeBansosRequest $request)
    {
        try {
            $user = auth()->user();

            $periode = PeriodeBansos::create([
                'id' => (string) Str::uuid(),
                'nama_periode' => $request->nama_periode,
                'jenis_bantuan' => $request->jenis_bantuan,
                'deskripsi' => $request->deskripsi,
                'status' => 'akan_datang',
                'dibuat_oleh' => $user->id,
            ]);

            Log::info('Periode bansos berhasil dibuat', [
                'user_id' => $user->id,
                'periode_id' => $periode->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Periode bansos berhasil dibuat',
                'data' => new PeriodeBansosResource($periode),
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            Log::error('Gagal membuat periode bansos', [
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

    public function detail($id)
    {
        try {
            $periode = PeriodeBansos::with('pembuatPeriode')->find($id);

            if (!$periode) {
                return response()->json([
                    'success' => false,
                    'message' => 'Periode bansos tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            Log::info('Detail periode bansos berhasil diambil', [
                'user_id' => auth()->id(),
                'periode_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Detail periode bansos berhasil diambil',
                'data' => new PeriodeBansosResource($periode),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil detail periode bansos', [
                'user_id' => auth()->id(),
                'periode_id' => $id ?? null,
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

    public function update($id, PeriodeBansosRequest $request)
    {
        try {
            $periode = PeriodeBansos::find($id);

            if (!$periode) {
                return response()->json([
                    'success' => false,
                    'message' => 'Periode bansos tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            $periode->update($request->validated());

            Log::info('Periode bansos berhasil diupdate', [
                'user_id' => auth()->id(),
                'periode_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Periode bansos berhasil diupdate',
                'data' => new PeriodeBansosResource($periode),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengupdate periode bansos', [
                'user_id' => auth()->id(),
                'periode_id' => $id ?? null,
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

    public function delete($id)
    {
        try {
            $periode = PeriodeBansos::find($id);

            if (!$periode) {
                return response()->json([
                    'success' => false,
                    'message' => 'Periode bansos tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            if ($periode->status !== 'akan_datang') {
                return response()->json([
                    'success' => false,
                    'message' => 'Periode dengan status ' . $periode->status . ' tidak dapat dihapus',
                ], Response::HTTP_BAD_REQUEST);
            }

            $periode->delete();

            Log::info('Periode bansos berhasil dihapus', [
                'user_id' => auth()->id(),
                'periode_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Periode bansos berhasil dihapus',
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menghapus periode bansos', [
                'user_id' => auth()->id(),
                'periode_id' => $id ?? null,
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
