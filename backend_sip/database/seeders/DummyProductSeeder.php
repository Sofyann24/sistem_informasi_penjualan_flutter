<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class DummyProductSeeder extends Seeder
{
    public function run(): void
    {

        try {
            $kursUSDToIDR = 15000;

            $response = Http::timeout(30)->get('https://dummyjson.com/products?limit=100');



            $products = $response->json()['products'];

            $categories = [];
            foreach ($products as $product) {
                $categoryName = $product['category'] ?? 'Lainnya';

                if (!isset($categories[$categoryName])) {
                    $existing = DB::table('categories')
                        ->where('name_category', $categoryName)
                        ->first();

                    if ($existing) {
                        $categories[$categoryName] = $existing->id;
                    } else {
                        $categories[$categoryName] = DB::table('categories')->insertGetId([
                            'name_category' => $categoryName,
                            'description_category' => 'Kategori ' . $categoryName,
                            'created_at' => now(),
                            'updated_at' => now(),
                        ]);
                    }
                }
            }

            DB::table('products')->delete();

            $dataToInsert = [];
            foreach ($products as $product) {
                $categoryName = $product['category'] ?? 'Lainnya';

                $priceUSD = $product['price'] ?? 0;
                $priceIDR = (int) round(($priceUSD * $kursUSDToIDR) / 100) * 100;                $priceBuyIDR = (int) ($priceIDR * 0.8);

                $dataToInsert[] = [
                    'name_product' => $product['title'] ?? 'Produk Tanpa Nama',
                    'price_buy'    => $priceBuyIDR,
                    'price_sell'   => $priceIDR,
                    'stock'        => $product['stock'] ?? 0,
                    'min_stock'    => 5,
                    'unit'         => 'pcs',
                    'category_id'  => $categories[$categoryName],
                    'description'  => $product['description'] ?? '',
                    'image'        => $product['thumbnail'] ?? '',
                    'created_at'   => now(),
                    'updated_at'   => now(),
                ];
            }

            DB::table('products')->insert($dataToInsert);
        } catch (\Exception $e) {
            // ⭐ TANGKAP ERROR
            $this->command->error('❌ ERROR: ' . $e->getMessage());
            $this->command->error('📍 File: ' . $e->getFile() . ':' . $e->getLine());
        }
    }
}
