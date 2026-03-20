<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        // Roles are now simple enum values in users table: admin, petugas, masyarakat
        // No permission setup needed - authorization handled by middleware
    }
}

