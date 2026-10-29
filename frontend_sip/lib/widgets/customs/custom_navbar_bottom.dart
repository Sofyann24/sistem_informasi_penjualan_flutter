import 'package:flutter/material.dart';

class CustomNavbarBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const new({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;

              return _buildNavItem(
                context: context,
                item: item,
                isSelected: isSelected,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// MODEL NAV ITEMS
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final Color activeColor;
  final Color inactiveColor;
  final double? iconSize;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.iconSize = 26,
  });
}

Widget _buildNavItem({
  required BuildContext context,
  required BottomNavItem item,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔥 Icon (dengan animasi)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isSelected ? 8 : 0),
            decoration: BoxDecoration(
              color: isSelected
                  ? item.activeColor.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isSelected ? item.activeIcon ?? item.icon : item.icon,
              color: isSelected ? item.activeColor : item.inactiveColor,
              size: item.iconSize ?? 26,
            ),
          ),
          const SizedBox(height: 4),
          // 🔥 Label
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? item.activeColor : item.inactiveColor,
            ),
          ),
        ],
      ),
    ),
  );
}
