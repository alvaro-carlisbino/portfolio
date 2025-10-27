import 'package:flutter/material.dart';
import 'package:repositoriobryzzen/l10n/app_translations.dart';

class LocalizationViewModel extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US'); // Inglês como padrão

  Locale get currentLocale => _currentLocale;

  String translate(String key) {
    final translations =
        AppTranslations.translations[_currentLocale.toString()] ??
            AppTranslations.translations['en_US']!;
    return translations[key] ?? key;
  }

  void setLocale(Locale locale) {
    if (!AppTranslations.translations.containsKey(locale.toString())) {
      return;
    }
    _currentLocale = locale;
    notifyListeners();
  }

  List<Locale> get supportedLocales => AppTranslations.translations.keys
      .map((e) => Locale(e.split('_')[0], e.split('_')[1]))
      .toList();
}
