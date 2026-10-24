<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TransactionController extends Controller
{
    public function index()
    {
        $transaction = Transaction::with(['customer', 'details.product'])->orderBy('created_at', 'desc')->get();

        return response()->json([
            'status' => 'success',
            'message' => 'Berhasil menampilkan transaksi',
            'data' => $transaction
        ], 201);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'customer_id' => 'nullable|exists:customers,id',
            'total_price' => 'required|integer|min:0',
            'total_items' => 'required|numeric|min:0',
            'total_profit' => 'required|numeric|min:0',
            'payment_method' => 'required|in:Cash,Hutang',
            'status' => 'required|in:Lunas,Belum Lunas',
            'notes' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|numeric|min:0.01',
            'items.*.price' => 'required|integer|min:0',
            'items.*.subtotal' => 'required|integer|min:0',
            'items.*.profit' => 'required|integer|min:0',
        ]);

        $validated['invoice_number'] = 'INV-' . date('Ymd') . '-' . str_pad(Transaction::whereDate('created_at', today())->count() + 1, 4, '0', STR_PAD_LEFT);

        $transaction = Transaction::create($validated);

        foreach ($validated['items'] as $item) {
            $transaction->details()->create([
                'product_id' => $item['product_id'],
                'quantity' => $item['quantity'],
                'price' => $item['price'],
                'subtotal' => $item['subtotal'],
                'profit' => $item['profit']
            ]);
            $product = Product::find($item['product_id']);
            if ($product) {
                $product->decrement('stock', $item['quantity']);
            }
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Transaksi Berhasil',
            'data' => $transaction->load('customer')
        ], 201);
    }

    public function show(int $id)
    {
        $transaction = Transaction::with(['customer', 'details.product'])->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $transaction
        ]);
    }

    public function destroy(int $id)
    {
        $transaction = Transaction::findOrFail($id);

        foreach ($transaction->details as $detail) {
            $product = Product::find($detail->product_id);

            if ($product) {
                $product->increment('stock', $detail->quantity);
            }
        }

        $transaction->details()->delete();
        $transaction->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Transaksi Berhasil dihapus'
        ]);
    }
}
