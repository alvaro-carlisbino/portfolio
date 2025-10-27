import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = true; // Tema escuro como padrão

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
