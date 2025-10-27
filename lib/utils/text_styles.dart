import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repositoriobryzzen/utils/colors.dart';

class AppTextStyles {
  // Títulos
  static TextStyle get h1 => GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get h2 => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        height: 1.3,
      );

  static TextStyle get h3 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // Corpo de texto
  static TextStyle get body1 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  static TextStyle get body2 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  // Elementos especiais
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.2,
      );

  // Helpers
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle get code => GoogleFonts.firaCode(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );
}
