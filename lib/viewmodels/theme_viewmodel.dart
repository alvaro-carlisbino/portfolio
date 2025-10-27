import 'package:flutter/material.dart';
import 'package:repositoriobryzzen/services/theme_service.dart';

class ThemeViewModel extends ChangeNotifier {
  final ThemeService _themeService;

  ThemeViewModel(this._themeService);

  bool get isDarkMode => _themeService.isDarkMode;
  ThemeMode get currentTheme => _themeService.currentTheme;

  void toggleTheme() {
    _themeService.toggleTheme();
    notifyListeners();
  }
}
