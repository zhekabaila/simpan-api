<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class PenugasanPetugas extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'penugasan_petugas';
    public $timestamps = false;

    protected $fillable = [
        'id',
        'periode_bansos_id',
        'petugas_id',
        'ditugaskan_oleh',
        'status',
        'catatan',
        'ditugaskan_pada',
        'updated_at',
    ];

    protected $casts = [
        'ditugaskan_pada' => 'datetime',
        'updated_at' => 'datetime',
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

    public function petugas(): BelongsTo
    {
        return $this->belongsTo(User::class, 'petugas_id');
    }

    public function ditugaskanOleh(): BelongsTo
    {
        return $this->belongsTo(User::class, 'ditugaskan_oleh');
    }

    public function distribusiBansos(): HasMany
    {
        return $this->hasMany(DistribusiBansos::class, 'penugasan_id');
    }
}
