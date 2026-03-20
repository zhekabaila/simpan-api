<?php

namespace App\Http\Controllers\Masyarakat;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Resources\NotifikasiResource;
use App\Models\Notifikasi;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;

class NotifikasiController extends Controller
{
    public function list(Request $request)
    {
        try {
            $user = auth()->user();
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $paginator = Notifikasi::where('user_id', $user->id)
                ->latest('created_at')
                ->paginate($limit, ['*'], 'page', $page);

            Log::info('Notifikasi user berhasil diambil', [
                'user_id' => $user->id,
                'count' => $paginator->count(),
            ]);

            return response()->json(
                PaginationHelper::format($paginator, NotifikasiResource::collection($paginator))
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil notifikasi', [
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

    public function markAsRead($id)
    {
        try {
            $user = auth()->user();
            $notifikasi = Notifikasi::where('id', $id)->where('user_id', $user->id)->first();

            if (!$notifikasi) {
                return response()->json([
                    'success' => false,
                    'message' => 'Notifikasi tidak ditemukan',
                ], Response::HTTP_NOT_FOUND);
            }

            $notifikasi->update([
                'sudah_dibaca' => true,
                'dibaca_pada' => now(),
            ]);

            Log::info('Notifikasi berhasil ditandai dibaca', [
                'user_id' => $user->id,
                'notifikasi_id' => $id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Notifikasi berhasil ditandai dibaca',
                'data' => new NotifikasiResource($notifikasi),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menandai notifikasi dibaca', [
                'user_id' => auth()->id(),
                'notifikasi_id' => $id ?? null,
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

    public function markAllAsRead()
    {
        try {
            $user = auth()->user();
            Notifikasi::where('user_id', $user->id)
                ->where('sudah_dibaca', false)
                ->update([
                    'sudah_dibaca' => true,
                    'dibaca_pada' => now(),
                ]);

            Log::info('Semua notifikasi berhasil ditandai dibaca', [
                'user_id' => $user->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Semua notifikasi berhasil ditandai dibaca',
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menandai semua notifikasi dibaca', [
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
