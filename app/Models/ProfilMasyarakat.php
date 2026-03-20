<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class ProfilMasyarakat extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'profil_masyarakat';

    protected $fillable = [
        'id',
        'user_id',
        'nik',
        'nama',
        'nomor_telepon',
        'tanggal_lahir',
        'jenis_kelamin',
        'alamat',
        'rt',
        'rw',
        'kelurahan',
        'kecamatan',
        'kota',
        'provinsi',
        'latitude',
        'longitude',
        'status_pernikahan',
        'jumlah_tanggungan',
        'status_pekerjaan',
        'penghasilan_bulanan',
        'status_kepemilikan_rumah',
    ];

    protected $casts = [
        'tanggal_lahir' => 'date',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'jumlah_tanggungan' => 'integer',
        'penghasilan_bulanan' => 'integer',
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

    public function fotoRumah(): HasMany
    {
        return $this->hasMany(FotoRumah::class);
    }

    public function pengajuanBansos(): HasMany
    {
        return $this->hasMany(PengajuanBansos::class);
    }

    public function qrcodePenerima()
    {
        return $this->hasOne(QrcodePenerima::class);
    }

    public function distribusiBansos(): HasMany
    {
        return $this->hasMany(DistribusiBansos::class);
    }
}
