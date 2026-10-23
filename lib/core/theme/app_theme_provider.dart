import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/core_service_providers.dart';
import 'package:riverpod_structure/core/services/storage/shared_pref.dart';

final appThemeProvider = NotifierProvider<AppThemeNotifier, ThemeMode>(
  AppThemeNotifier.new,
);

class AppThemeNotifier extends Notifier<ThemeMode> {
  static const String _themeKey = 'app_theme';

  SharedPref get _sharedPref => ref.read(sharedPrefProvider);

  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.system;
  }

  Future<void> _loadSavedTheme() async {
    final String? savedTheme = await _sharedPref.get(_themeKey) as String?;
    if (savedTheme != null) {
      state = switch (savedTheme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    }
  }

  void setLightTheme() {
    state = ThemeMode.light;
    _sharedPref.set(_themeKey, 'light');
  }

  void setDarkTheme() {
    state = ThemeMode.dark;
    _sharedPref.set(_themeKey, 'dark');
  }

  void setSystemTheme() {
    state = ThemeMode.system;
    _sharedPref.set(_themeKey, 'system');
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }
}
