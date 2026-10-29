// lib/widgets/toggle_view_widget.dart
import 'package:flutter/material.dart';

class ToggleViewWidget extends StatelessWidget {
  final bool isGrid;
  final VoidCallback onToggle;

  const ToggleViewWidget({
    super.key,
    required this.isGrid,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TOMBOL GRID
          GestureDetector(
            onTap: () {
              if (!isGrid) onToggle();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isGrid ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.grid_view_rounded,
                    size: 18,
                    color: isGrid ? Colors.white : Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),

          // TOMBOL LIST
          GestureDetector(
            onTap: () {
              if (isGrid) onToggle();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: !isGrid ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.list_rounded,
                    size: 18,
                    color: !isGrid ? Colors.white : Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
