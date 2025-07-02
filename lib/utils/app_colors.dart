import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 255, 255, 255);
  static const Color secondary = Color(0xFF2575FC);
  static const Color accent = Color.fromARGB(255, 41, 180, 146);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color textPrimary = Colors.black;

  static const Color goldenYellow = Color(0xFFFFD700);
  static const Color tealYellow = Color(0xFF00D7C0);
  static const Color darkTeal = Color(0xFF005F60);
  static const Color goldenAccent = Color(0xFFFFC107);
  static const Color textWhite = Colors.white;
  static const Color textSecondary = Color(0xFF757575);

  static LinearGradient get mainGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6A11CB), Color(0xFF2575FC), Color(0xFF00C9FF)],
    stops: [0.0, 0.5, 1.0],
  );

  static LinearGradient get cardGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFF5F5F5)],
  );

  static LinearGradient get buttonGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF00C9FF), Color(0xFF2575FC)],
  );

  static LinearGradient get backgroundGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFE6F7FF)],
  );

  static LinearGradient get goldenPurpleGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6A11CB), Color(0xFF2575FC), Color(0xFFFFD700)],
    stops: [0.0, 0.6, 1.0],
  );

  static LinearGradient get cardGradientV2 => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x306A11CB), Color(0x302575FC), Color(0x30FFD700)],
  );
}
