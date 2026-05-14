<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class PengajuanBansos extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'pengajuan_bansos';

    protected $fillable = [
        'id',
        'profil_masyarakat_id',
        'nomor_pengajuan',
        'status',
        'catatan_admin',
        'ditinjau_oleh',
        'ditinjau_pada',
        'diajukan_pada',
    ];

    protected $casts = [
        'diajukan_pada' => 'datetime',
        'ditinjau_pada' => 'datetime',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($model) {
            if (empty($model->id)) {
                $model->id = (string) Str::uuid();
            }
            if (empty($model->nomor_pengajuan)) {
                $model->nomor_pengajuan = self::generateNomerPengajuan();
            }
        });
    }

    public static function generateNomerPengajuan(): string
    {
        return DB::transaction(function () {
            $year = date('Y');
            // Dapatkan nomor urut terbesar yang pernah digunakan di tahun ini
            $maxSequence = self::whereRaw('YEAR(created_at) = ?', [$year])
                ->lockForUpdate()
                ->selectRaw("MAX(CAST(SUBSTRING_INDEX(nomor_pengajuan, '-', -1) AS UNSIGNED)) as max_seq")
                ->value('max_seq') ?? 0;

            $sequence = str_pad($maxSequence + 1, 5, '0', STR_PAD_LEFT);
            return "PNG-{$year}-{$sequence}";
        });
    }

    public function profilMasyarakat(): BelongsTo
    {
        return $this->belongsTo(ProfilMasyarakat::class);
    }

    public function ditinjauOleh(): BelongsTo
    {
        return $this->belongsTo(User::class, 'ditinjau_oleh');
    }
}
