import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
        brightness: Brightness.dark,
      );
}
