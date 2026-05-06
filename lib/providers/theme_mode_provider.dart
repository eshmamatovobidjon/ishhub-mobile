import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError('SharedPreferences must be provided at startup.');
});

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(AppConstants.kThemeMode, _encode(mode));
  }

  static ThemeMode _read(SharedPreferences prefs) {
    return _decode(prefs.getString(AppConstants.kThemeMode));
  }

  static ThemeMode _decode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String _encode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

final themeModeControllerProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController(ref.watch(sharedPreferencesProvider));
});

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._prefs) : super(_read(_prefs));

  static const supportedLanguageCodes = {'uz', 'ru', 'en'};

  final SharedPreferences _prefs;

  Future<void> setLocale(Locale locale) async {
    final normalized = _normalize(locale.languageCode);
    state = Locale(normalized);
    await _prefs.setString(AppConstants.kLocale, normalized);
  }

  static Locale _read(SharedPreferences prefs) {
    final saved = prefs.getString(AppConstants.kLocale);
    if (saved != null && supportedLanguageCodes.contains(saved)) {
      return Locale(saved);
    }

    final platformCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return Locale(_normalize(platformCode));
  }

  static String _normalize(String languageCode) {
    return supportedLanguageCodes.contains(languageCode) ? languageCode : 'uz';
  }
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
  return LocaleController(ref.watch(sharedPreferencesProvider));
});
