import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.sora(
        fontSize: 64,
        fontWeight: FontWeight.w800,
        height: 0.98,
        letterSpacing: -1.2,
      );

  static TextStyle get h2 => GoogleFonts.sora(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -0.6,
      );

  static TextStyle get h3 => GoogleFonts.sora(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.15,
      );

  static TextStyle get body1 => GoogleFonts.inter(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get body2 => GoogleFonts.inter(
        fontSize: 16.5,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      );

  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle get code => GoogleFonts.firaCode(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );
}
