import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repositoriobryzzen/internationalization/internationalization.dart';
import 'package:repositoriobryzzen/pages/home/home.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

bool darkThemeIsEnabled = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Alvaro Carlisbino',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      translations: Messages(),
      locale: const Locale('pt', 'BR'),
      fallbackLocale: const Locale('pt', 'BR'),
      theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme()),
    );
  }
}
