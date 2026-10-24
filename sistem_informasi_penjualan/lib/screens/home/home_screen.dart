import 'package:curve_clipper/curve_clipper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/utils/utils.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    final DateTime dateTimeNow = DateTime.now();
    final String today = DateFormat('dd MMM yyy', 'en_US').format(dateTimeNow);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Background Image
              CustomClipperWidget(
                mode: ClipperMode.convex,
                heightFromOrigin: 500,
                child: Container(
                  alignment: Alignment.center,
                  height: deviceSize.height * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text(
                    today,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Positioned(
            top: 150,
            left: 25,
            right: 25,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardBalance(),
                  SizedBox(height: 20),
                  Text('Menu Items', style: context.textTheme.titleMedium),
                  CardMenuItems(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
