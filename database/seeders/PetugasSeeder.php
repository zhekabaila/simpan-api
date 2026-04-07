<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class PetugasSeeder extends Seeder
{
    public function run(): void
    {
        User::firstOrCreate(
            ['email' => 'petugas1@simpan.id'],
            [
                'id' => (string) Str::uuid(),
                'nama' => 'Petugas 1',
                'password' => bcrypt('petugas123'),
                'aktif' => true,
                'role' => 'petugas',
            ]
        );

        User::firstOrCreate(
            ['email' => 'petugas2@simpan.id'],
            [
                'id' => (string) Str::uuid(),
                'nama' => 'Petugas 2',
                'password' => bcrypt('petugas123'),
                'aktif' => true,
                'role' => 'petugas',
            ]
        );
    }
}
