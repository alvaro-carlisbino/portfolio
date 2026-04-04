import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repositoriobryzzen/utils/colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: AppColors.brutalRed,
          surface: AppColors.white,
        ),
        cardColor: Colors.white,
        dividerColor: AppColors.borderStrong,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineLarge: GoogleFonts.sora(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
          titleLarge: GoogleFonts.sora(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: AppColors.neonYellow,
          surface: AppColors.darkGray,
        ),
        cardColor: AppColors.cardDark,
        dividerColor: AppColors.lightGray,
        useMaterial3: true,
        textTheme:
            GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
          headlineLarge: GoogleFonts.sora(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            color: AppColors.textLight,
          ),
          titleLarge: GoogleFonts.sora(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.textLight,
          ),
        ),
      );
}
