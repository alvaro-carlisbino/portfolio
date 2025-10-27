import 'package:flutter/material.dart';

class AppColors {
  // Cores Base
  static const black = Color(0xFF090909);
  static const darkGray = Color(0xFF1A1A1A);
  static const mediumGray = Color(0xFF2A2A2A);
  static const lightGray = Color(0xFFE0E0E0);
  static const white = Color(0xFFF5F5F5);

  // Acentuação
  static const neonBlue = Color(0xFF4CC9F0);
  static const neonPurple = Color(0xFF7B2CBF);
  static const neonPink = Color(0xFFFF006E);

  // Gradientes
  static const gradientStart = Color(0xFF4CC9F0);
  static const gradientMiddle = Color(0xFF7B2CBF);
  static const gradientEnd = Color(0xFFFF006E);

  // Backgrounds - Compatibilidade com código existente
  static Color get blackBackgroundColor => black;
  static Color get whiteContainerColor => white;
  static Color get blackContainerColor => darkGray;

  // Backgrounds
  static const darkBackground = black;
  static const cardDark = darkGray;
  static const cardLight = white;

  // Glassmorphism
  static Color get glassDark => const Color(0xFF1A1A1A).withOpacity(0.7);
  static Color get glassLight => Colors.white.withOpacity(0.1);

  // Texto
  static const textDark = Color(0xFF090909);
  static const textLight = Color(0xFFF5F5F5);
  static const textMuted = Color(0xFF6C757D);

  // Sombras
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: neonBlue.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  // Gradientes
  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [gradientStart, gradientMiddle, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get buttonGradient => LinearGradient(
        colors: [
          neonBlue.withOpacity(0.8),
          neonPurple.withOpacity(0.8),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
}
