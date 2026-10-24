<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    protected $fillable = ['name_category', 'description_category'];

    public function products()
    {
        $this->hasMany(Product::class);
    }
}
