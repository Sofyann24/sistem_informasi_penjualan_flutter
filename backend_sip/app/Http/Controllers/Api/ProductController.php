<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Berhasil menambahkan produk',
            'data' => $products
        ], 201);
    }

    public function store(Request $request)
    {
        // Validate
        $validated = $request->validate(
            [
                'barcode' => 'nullable|string|max:255|unique:products,barcode',
                'name_product' => 'required|string|max:255|unique:products,name_product',
                'price_buy' => 'required|int|min:0',
                'price_sell' => 'required|int|min:0',
                'stock' => 'required|int|min:0',
                'min_stock' => 'required|int|min:0',
                'category_id' => 'required|exists:categories,id',
                'unit' => 'required|string|max:255',
                'description' => 'nullable|string|max:255',
                'image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048'
            ]
        );
        if (empty($validated['barcode'])) {
            $validated['barcode'] = null;
        }
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $imageName = time() . '_' . $image->getClientOriginalName();
            $image->storeAs('products', $imageName, 'public');
            $validated['image'] = 'products/' . $imageName;
        }

        // $products = Product::created($validated);

        $products = Product::create([
            'barcode' => $validated['barcode'],
            'name_product' => $validated['name_product'],
            'price_buy' => $validated['price_buy'],
            'price_sell' => $validated['price_sell'],
            'stock' => $validated['stock'],
            'min_stock' => $validated['min_stock'],
            'category_id' => $validated['category_id'],
            'unit' => $validated['unit'],
            'description' => $validated['description'] ?? null,
            'image' => $validated['image'] ?? null,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Berhasil Menambahkan Produk',
            'data' => $products
        ], 201);
    }

    public function update(Request $request, int $id)
    {
        $product = Product::findOrFail($id);

        $validated = $request->validate([
            'barcode' => 'nullable|string|max:255|unique:products,barcode,' . $id,
            'name_product' => 'required|string|max:255|unique:products,name_product,' . $id,
            'price_buy' => 'required|integer|min:0',
            'price_sell' => 'required|integer|min:0',
            'stock' => 'required|integer|min:0',
            'min_stock' => 'required|integer|min:0',
            'category_id' => 'nullable|exists:categories,id',
            'unit' => 'required|string|max:255',
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        if (empty($validated['barcode'])) {
            $validated['barcode'] = null;
        }

        if ($request->hasFile('image')) {
            if ($product->image) {
                Storage::disk('public')->delete($product->image);
            }

            $image = $request->file('image');
            $imageName = time() . '_' . $image->getOriginalName();
            $image->storeAs('products', $imageName, 'public');
            $validated['image'] = 'products/' . $imageName;
        }

        $product->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Produk berhasil diupdate',
            'data' => $product,
        ]);
    }

    public function destroy(int $id)
    {
        $product = Product::findOrFail($id);

        if ($product->image) {
            Storage::disk('public')->delete($product->image);
        }

        $product->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Produk berhasil dihapus'
        ]);
    }
}
