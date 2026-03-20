<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class DistribusiBansos extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'distribusi_bansos';
    public $timestamps = false;

    protected $fillable = [
        'id',
        'periode_bansos_id',
        'profil_masyarakat_id',
        'petugas_id',
        'penugasan_id',
        'token_qr_dipindai',
        'status',
        'alasan_gagal',
        'latitude_scan',
        'longitude_scan',
        'diterima_pada',
    ];

    protected $casts = [
        'diterima_pada' => 'datetime',
        'latitude_scan' => 'decimal:8',
        'longitude_scan' => 'decimal:8',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($model) {
            if (empty($model->id)) {
                $model->id = (string) Str::uuid();
            }
        });
    }

    public function periodeBansos(): BelongsTo
    {
        return $this->belongsTo(PeriodeBansos::class);
    }

    public function profilMasyarakat(): BelongsTo
    {
        return $this->belongsTo(ProfilMasyarakat::class);
    }

    public function petugas(): BelongsTo
    {
        return $this->belongsTo(User::class, 'petugas_id');
    }

    public function penugasan(): BelongsTo
    {
        return $this->belongsTo(PenugasanPetugas::class, 'penugasan_id');
    }
}
