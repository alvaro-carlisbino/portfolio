import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repositoriobryzzen/config/theme/app_theme.dart';
import 'package:repositoriobryzzen/services/theme_service.dart';
import 'package:repositoriobryzzen/viewmodels/theme_viewmodel.dart';
import 'package:repositoriobryzzen/viewmodels/localization_viewmodel.dart';
import 'package:repositoriobryzzen/pages/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeViewModel>(
            create: (_) => ThemeViewModel(ThemeService())),
        ChangeNotifierProvider<LocalizationViewModel>(
            create: (_) => LocalizationViewModel()),
      ],
      child: Consumer2<ThemeViewModel, LocalizationViewModel>(
        builder: (context, theme, localization, _) => MaterialApp(
          title: 'Alvaro Carlisbino',
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
          locale: localization.currentLocale,
          supportedLocales: localization.supportedLocales,
          themeMode: theme.currentTheme,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
        ),
      ),
    );
  }
}
