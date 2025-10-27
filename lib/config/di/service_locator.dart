import 'package:get_it/get_it.dart';
import 'package:repositoriobryzzen/viewmodels/theme_viewmodel.dart';
import 'package:repositoriobryzzen/viewmodels/localization_viewmodel.dart';
import 'package:repositoriobryzzen/services/theme_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<ThemeService>(() => ThemeService());

  // ViewModels
  getIt.registerFactory<ThemeViewModel>(
      () => ThemeViewModel(getIt<ThemeService>()));
  getIt.registerFactory<LocalizationViewModel>(() => LocalizationViewModel());
}
