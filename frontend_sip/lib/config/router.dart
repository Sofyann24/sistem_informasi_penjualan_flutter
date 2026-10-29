import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistem_informasi_penjualan/screens/auth/login_screen.dart';
import 'package:sistem_informasi_penjualan/screens/auth/registrasi_screen.dart';

// 2. Buat konfigurasi router
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          _buildPageWithTransition(context, state, const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) =>
          _buildPageWithTransition(context, state, const RegistrationScreen()),
    ),
  ],
);

// 3. Fungsi helper untuk transisi kustom
CustomTransitionPage _buildPageWithTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 🎯 Animasi MASUK (dari kanan ke kiri)
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      // GABUNGIN ANIMASI MASUK & KELUAR
      var offsetAnimation = animation.drive(tween);

      // 🎯 Animasi KELUAR (berlawanan arah)
      // Pas pop, dia bakal slide ke kanan (balik)
      secondaryAnimation.drive(
        Tween(
          begin: Offset.zero,
          end: Offset(1.0, 0.0),
        ).chain(CurveTween(curve: curve)),
      );

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
