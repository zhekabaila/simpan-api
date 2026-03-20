<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class MasyarakatSeeder extends Seeder
{
    public function run(): void
    {
        User::firstOrCreate(
            ['email' => 'masyarakat1@sibansos.id'],
            [
                'id' => (string) Str::uuid(),
                'nama' => 'masyarakat 1',
                'password' => bcrypt('masyarakat123'),
                'aktif' => true,
                'role' => 'masyarakat',
            ]
        );

        User::firstOrCreate(
            ['email' => 'masyarakat2@sibansos.id'],
            [
                'id' => (string) Str::uuid(),
                'nama' => 'masyarakat 2',
                'password' => bcrypt('masyarakat123'),
                'aktif' => true,
                'role' => 'masyarakat',
            ]
        );
    }
}
