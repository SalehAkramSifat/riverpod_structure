import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/storage/local_storage_service.dart';

final appThemeProvider = NotifierProvider<AppThemeNotifier, ThemeMode>(
  AppThemeNotifier.new,
);

class AppThemeNotifier extends Notifier<ThemeMode> {
  LocalStorageService get _storage => ref.read(localStorageProvider);

  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.system;
  }

  Future<void> _loadSavedTheme() async {
    final String? savedTheme = await _storage.getThemeMode();
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
    _storage.saveThemeMode('light');
  }

  void setDarkTheme() {
    state = ThemeMode.dark;
    _storage.saveThemeMode('dark');
  }

  void setSystemTheme() {
    state = ThemeMode.system;
    _storage.saveThemeMode('system');
  }

  void toggleTheme() {
    final isCurrentlyDark = state == ThemeMode.dark ||
        (state == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);
    if (isCurrentlyDark) {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }
}
