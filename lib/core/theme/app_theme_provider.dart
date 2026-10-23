import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/auth_service.dart';

final appThemeProvider = NotifierProvider<AppThemeNotifier, ThemeMode>(
  AppThemeNotifier.new,
);

class AppThemeNotifier extends Notifier<ThemeMode> {
  static const String _themeKey = 'app_theme';

  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.system;
  }

  Future<void> _loadSavedTheme() async {
    final String? savedTheme = await AuthService.read(_themeKey);
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
    AuthService.write(_themeKey, 'light');
  }

  void setDarkTheme() {
    state = ThemeMode.dark;
    AuthService.write(_themeKey, 'dark');
  }

  void setSystemTheme() {
    state = ThemeMode.system;
    AuthService.write(_themeKey, 'system');
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }
}
