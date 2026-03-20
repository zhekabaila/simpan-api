<?php

namespace App\Http\Controllers\Admin;

use App\Helpers\PaginationHelper;
use App\Http\Controllers\Controller;
use App\Http\Resources\NotifikasiResource;
use App\Http\Resources\UserResource;
use App\Models\Notifikasi;
use App\Models\User;
use App\Services\NotifikasiService;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;

class NotifikasiAdminController extends Controller
{
    public function __construct(
        private NotifikasiService $notifikasiService,
    ) {}

    public function list(Request $request)
    {
        try {
            $limit = min($request->input('limit', 15), 100);
            $page = $request->input('page', 1);

            $query = Notifikasi::with('user');

            if ($request->has('jenis') && $request->jenis) {
                $query->where('jenis', $request->jenis);
            }

            if ($request->has('user_id') && $request->user_id) {
                $query->where('user_id', $request->user_id);
            }

            $paginator = $query->latest('created_at')
                ->paginate($limit, ['*'], 'page', $page);

            Log::info('Daftar notifikasi admin berhasil diambil', [
                'user_id' => auth()->id(),
                'count' => $paginator->count(),
            ]);

            return response()->json(
                PaginationHelper::format($paginator, NotifikasiResource::collection($paginator))
            );
        } catch (\Exception $e) {
            Log::error('Gagal mengambil daftar notifikasi', [
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

    public function send(Request $request)
    {
        try {
            $request->validate([
                'user_id' => 'required|uuid|exists:users,id',
                'judul' => 'required|string',
                'pesan' => 'required|string',
            ]);

            $notifikasi = $this->notifikasiService->kirim(
                $request->user_id,
                $request->judul,
                $request->pesan,
                'umum'
            );

            Log::info('Notifikasi manual berhasil dikirim', [
                'user_id' => auth()->id(),
                'notifikasi_id' => $notifikasi->id,
                'penerima_id' => $request->user_id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Notifikasi berhasil dikirim',
                'data' => new NotifikasiResource($notifikasi),
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            Log::error('Gagal mengirim notifikasi manual', [
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
