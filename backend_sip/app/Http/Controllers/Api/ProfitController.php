<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Carbon\Carbon;
use Illuminate\Http\Request;

class ProfitController extends Controller
{
    // app/Http/Controllers/Api/DashboardController.php

    public function todaySummary()
    {
        $today = Carbon::today();

        // ⭐ AMBIL TRANSAKSI HARI INI
        $transactions = Transaction::whereDate('created_at', $today)->get();

        // ⭐ TOTAL PROFIT (TINGGAL SUM)
        $totalProfit = $transactions->sum('total_profit');

        // ⭐ UANG MASUK (TOTAL HARGA JUAL)
        $totalIncome = $transactions->sum('total_price');

        // ⭐ UANG KELUAR (MODAL)
        $totalOutcome = $totalIncome - $totalProfit;

        return response()->json([
            'status' => 'success',
            'data' => [
                'date' => $today->format('Y-m-d'),
                'total_transactions' => $transactions->count(),
                'total_profit' => $totalProfit,
                'total_income' => $totalIncome,
                'total_outcome' => $totalOutcome,
            ],
        ]);
    }

    public function rangeSummary() {}
}
