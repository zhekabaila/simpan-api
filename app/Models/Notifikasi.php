<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Notifikasi extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'notifikasi';
    public $timestamps = false;

    protected $fillable = [
        'id',
        'user_id',
        'judul',
        'pesan',
        'jenis',
        'referensi_id',
        'jenis_referensi',
        'sudah_dibaca',
        'created_at',
        'dibaca_pada',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'dibaca_pada' => 'datetime',
        'sudah_dibaca' => 'boolean',
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

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
