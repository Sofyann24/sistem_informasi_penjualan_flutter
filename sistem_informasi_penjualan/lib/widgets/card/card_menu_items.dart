import 'package:flutter/material.dart';

class CardMenuItems extends StatelessWidget {
  const CardMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildMenuItem(
          icon: Icons.assessment_outlined,
          title: 'Laporan',
          onTap: () {
            Navigator.pushNamed(context, '/reportScreen');
          },
        ),
        _buildMenuItem(
          icon: Icons.history,
          title: 'Transaksi',
          onTap: () {
            Navigator.pushNamed(context, '/historyTransaction');
          },
        ),
        _buildMenuItem(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Daftar Utang',
          onTap: () {
            Navigator.pushNamed(context, '/debtList');
          },
        ),
        _buildMenuItem(
          icon: Icons.category_outlined,
          title: 'Kategori',
          onTap: () {
            Navigator.pushNamed(context, '/categoryScreen');
          },
        ),
        _buildMenuItem(
          icon: Icons.people_outline,
          title: 'Pelanggan',
          onTap: () {
            Navigator.pushNamed(context, '/customerScreen');
          },
        ),
        _buildMenuItem(
          icon: Icons.inventory_2_outlined,
          title: 'Stock',
          onTap: () {
            Navigator.pushNamed(context, '/stockScreen');
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(
                0,
                158,
                158,
                158,
              ).withValues(alpha: 0.3),
              blurRadius: 4, // Seberapa kabur
              offset: const Offset(0, 5),
            ),
          ],
          color: const Color.fromARGB(255, 246, 246, 247),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
