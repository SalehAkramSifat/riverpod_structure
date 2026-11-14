import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_structure/core/logging/logger.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

/// Service responsible for managing general app configurations,
/// user preferences (e.g. Theme, Onboarding, Language), and local cache.
class LocalStorageService {
  static const String _themeKey = 'app_theme';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _localeKey = 'app_locale';

  final FlutterSecureStorage _storage;

  LocalStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // Generic key-value methods
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, stack) {
      AppLogger.error('LocalStorage write error ($key)',
          error: e, stackTrace: stack);
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e, stack) {
      AppLogger.error('LocalStorage read error ($key)',
          error: e, stackTrace: stack);
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, stack) {
      AppLogger.error('LocalStorage delete error ($key)',
          error: e, stackTrace: stack);
    }
  }

  // Theme preference
  Future<String?> getThemeMode() async => read(_themeKey);

  Future<void> saveThemeMode(String mode) async => write(_themeKey, mode);

  // Onboarding flag
  Future<bool> isOnboardingCompleted() async {
    final value = await read(_onboardingKey);
    return value == 'true';
  }

  Future<void> setOnboardingCompleted({bool completed = true}) async {
    await write(_onboardingKey, completed.toString());
  }

  // Locale preference
  Future<String?> getLocale() async => read(_localeKey);

  Future<void> saveLocale(String localeCode) async =>
      write(_localeKey, localeCode);
}
