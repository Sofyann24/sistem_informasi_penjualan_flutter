<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoriesController extends Controller
{
    // Index
    public function index()
    {
        $categories = Category::orderBy('name_category', 'asc')->get();

        return response()->json([
            'status' => 'success',
            'massage' => 'Kategori berhasil ditambahkan',
            'data' => $categories
        ], 201);
    }

    // Create
    public function store(Request $request)
    {
        $validate = $request->validate([
            'name_category' => 'required|string|max:255|unique:categories,name_category',
            'description' => 'nullable|string|max:255',
        ]);

        $category = Category::create([
            'name_category' => $validate['name_category'],
            'description_category' => $validate['description'] ?? null
        ]);

        return response()->json([
            'status' => 'success',
            'massage' => 'Berhasil menambahkan kategori',
            'data' => $category
        ], 201);
    }

    public function destroy($id)
    {
        try {
            $category = Category::find($id);

            if (!$category) {
                return response()->json([
                    'status' => 'error',
                    'message' => "data could not be found",

                ], 200);
            }

            $category->delete();
            return response()->json([
                'status' => 'success',
                'message' => 'category has been delete'
            ]);
        } catch (\Throwable $th) {
            return response()->json(
                [
                    'status' => 'error',
                    'message' => 'Gagal hapus data pelanggan',
                    'error' => $th->getMessage()
                ],
                500
            );
        }
    }
}
