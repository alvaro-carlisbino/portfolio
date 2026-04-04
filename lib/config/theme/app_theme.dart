import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repositoriobryzzen/utils/colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: AppColors.neonBlue,
          surface: AppColors.white,
        ),
        cardColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineLarge: GoogleFonts.sora(
            fontSize: 44,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
          titleLarge: GoogleFonts.sora(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: AppColors.neonBlue,
          surface: AppColors.darkGray,
        ),
        cardColor: AppColors.cardDark,
        textTheme:
            GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
          headlineLarge: GoogleFonts.sora(
            fontSize: 44,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
          titleLarge: GoogleFonts.sora(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
        ),
      );
}
