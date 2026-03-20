<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class FotoRumah extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'foto_rumah';
    public $timestamps = false;

    protected $fillable = [
        'id',
        'profil_masyarakat_id',
        'jenis_foto',
        'path_foto',
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

    public function profilMasyarakat(): BelongsTo
    {
        return $this->belongsTo(ProfilMasyarakat::class);
    }
}
