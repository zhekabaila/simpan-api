<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class DokumentasiDistribusi extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'dokumentasi_distribusi';
    public $timestamps = false;

    protected $fillable = [
        'id',
        'periode_bansos_id',
        'petugas_id',
        'jenis_dokumentasi',
        'path_dokumentasi',
        'keterangan',
        'diunggah_pada',
    ];

    protected $casts = [
        'diunggah_pada' => 'datetime',
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
}
