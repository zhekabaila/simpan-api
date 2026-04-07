<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        User::firstOrCreate(
            ['email' => 'admin@simpan.id'],
            [
                'id' => (string) Str::uuid(),
                'nama' => 'Super Admin',
                'password' => bcrypt('admin123'),
                'aktif' => true,
                'role' => 'admin',
            ]
        );
    }
}
