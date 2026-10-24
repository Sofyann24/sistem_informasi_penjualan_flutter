// lib/widgets/app_snackbar.dart
import 'package:flutter/material.dart';

class AppSnackbar {
  // ============================================================
  // 🔥 SHOW SNACKBAR (Static Method)
  // ============================================================
  static void show({
    required BuildContext context,
    required String message,
    bool isError = true,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    // Hapus snackbar sebelumnya biar gak numpuk
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Tampilkan snackbar baru
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: behavior,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: duration,
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 🔥 SHOW SUCCESS (Wrapper)
  // ============================================================
  static void success({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context: context,
      message: message,
      isError: false,
      duration: duration,
    );
  }

  // ============================================================
  // 🔥 SHOW ERROR (Wrapper)
  // ============================================================
  static void error({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context: context, message: message, isError: true, duration: duration);
  }

  // ============================================================
  // 🔥 SHOW INFO (Wrapper)
  // ============================================================
  static void info({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: duration,
        backgroundColor: Colors.blue.shade700,
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 🔥 SHOW WARNING (Wrapper)
  // ============================================================
  static void warning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: duration,
        backgroundColor: Colors.orange.shade700,
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
