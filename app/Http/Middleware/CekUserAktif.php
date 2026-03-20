<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

class CekUserAktif
{
    public function handle(Request $request, Closure $next): Response
    {
        if (auth()->check() && !auth()->user()->aktif) {
            Log::warning('Akses ditolak - akun nonaktif', [
                'user_id' => auth()->id(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Akun Anda dinonaktifkan',
            ], 403);
        }

        return $next($request);
    }
}
