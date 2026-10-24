<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;
use Override;

class Product extends Model
{
    protected $fillable = [
        'barcode',
        'name_product',
        'price_buy',
        'price_sell',
        'stock',
        'min_stock',
        'category_id',
        'unit',
        'description',
        'image',
    ];

    public function category()
    {
        $this->belongsTo(Category::class);
    }

    protected $appends = ['image_url'];

    public function getImageUrlAttribute()
    {
        if (!$this->image) return null;

        if (str_starts_with($this->image, 'http://') || str_starts_with($this->image, 'https://')) {
            return $this->image;
        }
        return $this->image ? asset('storage/' . $this->image) : null;
    }

    #[Override]
    protected static function booted()
    {
        static::deleting(function ($product) {
            if ($product->image) {
                Storage::disk('public')->delete($product->image);
            }
        });
    }

    public function unit()
    {
        return $this->belongsTo(Unit::class);
    }

    public function getPriceFormattedAttribute()
    {
        $unitSymbol = $this->unit?->symbol ?? 'pcs';
        return 'Rp ' . number_format($this->price_sell, 0, ',', '.') . ' / ' . $unitSymbol;
    }
}
