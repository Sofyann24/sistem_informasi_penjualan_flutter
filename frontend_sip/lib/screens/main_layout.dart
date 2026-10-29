import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/screens/settings/settings.dart';
import 'package:sistem_informasi_penjualan/widgets/customs/custom_navbar_bottom.dart';
import 'screens.dart';

class MainLayout extends StatefulWidget {
  const new({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 1;

  final List<Widget> _screens = [HomeScreen(), CashierScreen(), SettingScreen()];

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(icon: Icons.home, label: 'Home'),
    BottomNavItem(icon: Icons.shopping_cart, label: 'Cashier'),
    BottomNavItem(icon: Icons.settings, label: 'Setting'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(children: [_screens[currentIndex]]),
      bottomNavigationBar: CustomNavbarBottom(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
}
