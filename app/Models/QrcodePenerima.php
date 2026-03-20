<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class QrcodePenerima extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'qrcode_penerima';
    public $timestamps = false;

    protected $fillable = [
        'id',
        'profil_masyarakat_id',
        'token_qr',
        'path_gambar_qr',
        'aktif',
        'created_at',
        'kedaluwarsa_pada',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'kedaluwarsa_pada' => 'datetime',
        'aktif' => 'boolean',
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
