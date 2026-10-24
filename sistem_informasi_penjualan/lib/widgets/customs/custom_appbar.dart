import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(title: Text(title), centerTitle: true, elevation: 1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
