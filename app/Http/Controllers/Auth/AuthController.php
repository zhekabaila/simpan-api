<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Tymon\JwtAuth\Exceptions\JwtException;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthController extends Controller
{
    public function register(RegisterRequest $request)
    {
        try {
            // Create user
            $user = User::create([
                'id' => (string) Str::uuid(),
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'aktif' => true,
                'role' => 'masyarakat',
            ]);

            // Generate JWT token
            $token = JWTAuth::fromUser($user);

            Log::info('User berhasil registrasi', [
                'user_id' => $user->id,
                'email' => $user->email,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Registrasi berhasil',
                'data' => [
                    'access_token' => $token,
                    'token_type' => 'bearer',
                    'expires_in' => config('jwt.ttl') * 60,
                    'user' => new UserResource($user),
                ],
            ], Response::HTTP_CREATED);
        } catch (\Exception $e) {
            Log::error('Registrasi gagal', [
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

    public function login(LoginRequest $request)
    {
        try {
            $credentials = $request->only('email', 'password');

            // Find user
            $user = User::with('profilMasyarakat')->where('email', $credentials['email'])->first();

            if (!$user || !Hash::check($credentials['password'], $user->password)) {
                Log::warning('Login gagal - kredensial tidak valid', [
                    'email' => $credentials['email'],
                ]);
                return response()->json([
                    'success' => false,
                    'message' => 'Email atau password salah',
                ], Response::HTTP_UNAUTHORIZED);
            }

            // Check if user is active
            if (!$user->aktif) {
                Log::warning('Login gagal - akun dinonaktifkan', [
                    'user_id' => $user->id,
                    'email' => $user->email,
                ]);
                return response()->json([
                    'success' => false,
                    'message' => 'Akun Anda dinonaktifkan',
                ], Response::HTTP_FORBIDDEN);
            }

            // Generate token
            $token = JwtAuth::fromUser($user);

            Log::info('User berhasil login', [
                'user_id' => $user->id,
                'email' => $user->email,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Login berhasil',
                'data' => [
                    'access_token' => $token,
                    'token_type' => 'bearer',
                    'expires_in' => config('jwt.ttl') * 60,
                    'user' => new UserResource($user),
                ],
            ]);
        } catch (\Exception $e) {
            Log::error('Login gagal', [
                'email' => $request->email ?? null,
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

    public function logout()
    {
        try {
            JwtAuth::invalidate(JwtAuth::getToken());

            Log::info('User berhasil logout', [
                'user_id' => auth()->id(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Logout berhasil',
            ]);
        } catch (JwtException $e) {
            Log::error('Logout gagal', [
                'user_id' => auth()->id(),
                'error' => $e->getMessage(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Logout gagal',
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function refresh()
    {
        try {
            $token = JwtAuth::refresh(JwtAuth::getToken());

            Log::info('Token berhasil di-refresh', [
                'user_id' => auth()->id(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Token berhasil di-refresh',
                'data' => [
                    'access_token' => $token,
                    'token_type' => 'bearer',
                    'expires_in' => config('jwt.ttl') * 60,
                ],
            ]);
        } catch (JwtException $e) {
            Log::error('Refresh token gagal', [
                'user_id' => auth()->id(),
                'error' => $e->getMessage(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Refresh token gagal',
            ], Response::HTTP_UNAUTHORIZED);
        }
    }

    public function me()
    {
        try {
            $user = auth()->user()->load('profilMasyarakat');

            return response()->json([
                'success' => true,
                'message' => 'Data user berhasil diambil',
                'data' => new UserResource($user),
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil data user', [
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
