import 'package:flutter/material.dart';

class AppColors {
  static const black = Color(0xFF0D0D0D);
  static const darkGray = Color(0xFF1A1A1A);
  static const mediumGray = Color(0xFF2A2A2A);
  static const lightGray = Color(0xFFF1F1F1);
  static const white = Color(0xFFFFF6E9);

  static const neonBlue = Color(0xFF176BFF);
  static const neonPurple = Color(0xFF6D2CFF);
  static const neonPink = Color(0xFFFF3F81);
  static const neonYellow = Color(0xFFFFD60A);
  static const acidGreen = Color(0xFFB8F916);
  static const brutalRed = Color(0xFFFF3B30);

  static const gradientStart = neonBlue;
  static const gradientMiddle = neonPurple;
  static const gradientEnd = neonPink;

  static const darkBackground = Color(0xFF121212);
  static const cardDark = Color(0xFF1B1B1B);
  static const cardLight = white;
  static const textDark = Color(0xFF121212);
  static const textLight = Color(0xFFF9F9F9);
  static const textMuted = Color(0xFF6D6D6D);
  static const borderStrong = Color(0xFF121212);

  static Color get blackBackgroundColor => darkBackground;
  static Color get whiteContainerColor => white;
  static Color get blackContainerColor => cardDark;
  static Color get glassDark => const Color(0xFF141D32).withValues(alpha: 0.8);
  static Color get glassLight =>
      const Color(0xFFF9FAFF).withValues(alpha: 0.85);

  static List<BoxShadow> get cardShadow => <BoxShadow>[
        BoxShadow(
          color: borderStrong.withValues(alpha: 0.22),
          blurRadius: 0,
          offset: const Offset(8, 8),
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
