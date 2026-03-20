<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class PeriodeBansos extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'periode_bansos';

    protected $fillable = [
        'id',
        'nama_periode',
        'jenis_bantuan',
        'deskripsi',
        'tanggal_mulai',
        'tanggal_selesai',
        'status',
        'dibuat_oleh',
    ];

    protected $casts = [
        'tanggal_mulai' => 'date',
        'tanggal_selesai' => 'date',
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

    public function pembuatPeriode(): BelongsTo
    {
        return $this->belongsTo(User::class, 'dibuat_oleh');
    }

    public function penugasanPetugas(): HasMany
    {
        return $this->hasMany(PenugasanPetugas::class);
    }

    public function distribusiBansos(): HasMany
    {
        return $this->hasMany(DistribusiBansos::class);
    }
}
