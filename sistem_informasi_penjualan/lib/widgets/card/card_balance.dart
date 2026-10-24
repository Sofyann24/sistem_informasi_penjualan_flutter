import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/helpers/helpers.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';

class CardBalance extends StatefulWidget {
  const CardBalance({super.key});

  @override
  State<CardBalance> createState() => _CardBalanceState();
}

class _CardBalanceState extends State<CardBalance> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // PANGGIL DASHBOARD
      context.read<ProfitProvider>().fetchTodaySummary();

      // PANGGIL YANG LAIN (KALO ADA)
      context.read<CategoryProvider>().fetchCategories();
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profitProvider = context.watch<ProfitProvider>();
    final data = profitProvider.todayData;
    return Column(
      children: [
        // CARD PROFIT (BESAR)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A6CF7), Color(0xFF6C5CE7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A6CF7).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Untung Hari Ini',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              if (profitProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (data == null)
                const Center(child: Text('Gagal memuat data'))
              else ...[
              Text(
                AppFormatters.formatCurrency(data.totalProfit),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${data.totalTransactions} transaksi',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              ],
            ],
          ),
        ),
        if (data != null) ...[
        const SizedBox(height: 16),

        // UANG MASUK & KELUAR
        Row(
          children: [
            // UANG MASUK
            Expanded(
              child: _buildStatCard(
                title: 'Uang Masuk',
                value: AppFormatters.formatCurrency(data.totalIncome),
                icon: Icons.arrow_downward_rounded,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),

            // UANG KELUAR
            Expanded(
              child: _buildStatCard(
                title: 'Uang Keluar',
                value: AppFormatters.formatCurrency(data.totalOutcome),
                icon: Icons.arrow_upward_rounded,
                color: Colors.red,
              ),
            ),
          ],
        ),
        ],
      ],
    );
  }

  // WIDGET CARD STATISTIK
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
