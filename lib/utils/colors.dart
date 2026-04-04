import 'package:flutter/material.dart';

class AppColors {
  static const black = Color(0xFF0B1020);
  static const darkGray = Color(0xFF111A2E);
  static const mediumGray = Color(0xFF1C2943);
  static const lightGray = Color(0xFFE7EAF0);
  static const white = Color(0xFFF8F9FB);

  static const neonBlue = Color(0xFF4F8CFF);
  static const neonPurple = Color(0xFF7757FF);
  static const neonPink = Color(0xFFFF5DA8);

  static const gradientStart = neonBlue;
  static const gradientMiddle = neonPurple;
  static const gradientEnd = neonPink;

  static const darkBackground = black;
  static const cardDark = darkGray;
  static const cardLight = white;
  static const textDark = Color(0xFF131A2A);
  static const textLight = Color(0xFFF4F6FA);
  static const textMuted = Color(0xFF6B7385);

  static Color get blackBackgroundColor => darkBackground;
  static Color get whiteContainerColor => white;
  static Color get blackContainerColor => cardDark;
  static Color get glassDark => const Color(0xFF141D32).withValues(alpha: 0.8);
  static Color get glassLight =>
      const Color(0xFFF9FAFF).withValues(alpha: 0.85);

  static List<BoxShadow> get cardShadow => <BoxShadow>[
        BoxShadow(
          color: neonBlue.withValues(alpha: 0.10),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: <Color>[gradientStart, gradientMiddle, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get buttonGradient => const LinearGradient(
        colors: <Color>[gradientStart, gradientMiddle],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
}
