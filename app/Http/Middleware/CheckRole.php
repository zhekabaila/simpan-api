<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    public function handle(Request $request, Closure $next, string $role): Response
    {
        if (!auth()->check()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized'
            ], 401);
        }

        if (auth()->user()->role !== $role) {
            return response()->json([
                'success' => false,
                'message' => 'Access denied. Required role: ' . $role
            ], 403);
        }

        return $next($request);
    }
}
