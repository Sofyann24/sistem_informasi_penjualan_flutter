<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Unit extends Model
{
    protected $fillable = [
        'name_unit',
        'symbol',
        'description'
    ];

    public function products()
    {
        return $this->hasMany(Product::class);
    }

    public function getFullNameAttribute()
    {
        return "{$this->name} ({$this->symbol})";
    }
}
