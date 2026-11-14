import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_structure/core/logging/logger.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// A secure storage service for managing encrypted credentials, tokens,
/// and sensitive user data using [FlutterSecureStorage].
class SecureStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _roleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';

  final FlutterSecureStorage _storage;

  // Cached in-memory token for fast synchronous access
  static String? _cachedToken;
  static String? _cachedRole;
  static String? _cachedUserId;
  static Map<String, dynamic>? _cachedUserData;
  static bool _isInitialized = false;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(resetOnError: true),
              iOptions:
                  IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  /// Initialize and warm up cache
  static Future<void> init() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(resetOnError: true),
      iOptions: KeychainAccessibility.first_unlock ==
              KeychainAccessibility.first_unlock
          ? IOSOptions(accessibility: KeychainAccessibility.first_unlock)
          : IOSOptions(),
    );
    try {
      _cachedToken = await storage.read(key: _tokenKey);
      _cachedRole = await storage.read(key: _roleKey);
      _cachedUserId = await storage.read(key: _userIdKey);

      final rawUserData = await storage.read(key: _userDataKey);
      if (rawUserData != null && rawUserData.isNotEmpty) {
        _cachedUserData = jsonDecode(rawUserData) as Map<String, dynamic>;
      }
      _isInitialized = true;
      AppLogger.info('🔐 SecureStorageService initialized.');
    } catch (e, stack) {
      AppLogger.error('Failed to initialize SecureStorageService',
          error: e, stackTrace: stack);
    }
  }

  // Fast synchronous getters
  bool get hasToken => _cachedToken != null && _cachedToken!.trim().isNotEmpty;
  String? get token => _cachedToken;
  String? get role => _cachedRole;
  String? get userId => _cachedUserId;
  Map<String, dynamic>? get userData => _cachedUserData;
  bool get isInitialized => _isInitialized;

  // Static getters for top-level access if needed outside Riverpod
  static String? get currentToken => _cachedToken;
  static bool get isAuthenticated =>
      _cachedToken != null && _cachedToken!.trim().isNotEmpty;

  // Token management
  Future<void> saveToken(String token, {String? id}) async {
    try {
      _cachedToken = token;
      await _storage.write(key: _tokenKey, value: token);
      if (id != null) {
        _cachedUserId = id;
        await _storage.write(key: _userIdKey, value: id);
      }
      AppLogger.info('Auth token saved securely.');
    } catch (e, stack) {
      AppLogger.error('Error saving auth token', error: e, stackTrace: stack);
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } catch (e, stack) {
      AppLogger.error('Error saving refresh token',
          error: e, stackTrace: stack);
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveRole(String role) async {
    try {
      _cachedRole = role;
      await _storage.write(key: _roleKey, value: role);
    } catch (e, stack) {
      AppLogger.error('Error saving role', error: e, stackTrace: stack);
    }
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    try {
      _cachedUserData = data;
      await _storage.write(key: _userDataKey, value: jsonEncode(data));
    } catch (e, stack) {
      AppLogger.error('Error saving user data', error: e, stackTrace: stack);
    }
  }

  Future<void> clearAuthData() async {
    try {
      _cachedToken = null;
      _cachedRole = null;
      _cachedUserId = null;
      _cachedUserData = null;
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _roleKey);
      await _storage.delete(key: _userIdKey);
      await _storage.delete(key: _userDataKey);
      AppLogger.info('Auth credentials cleared from secure storage.');
    } catch (e, stack) {
      AppLogger.error('Error clearing auth credentials',
          error: e, stackTrace: stack);
    }
  }

  // Generic key-value helpers
  Future<void> write(String key, String value) async =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) async => _storage.read(key: key);

  Future<void> delete(String key) async => _storage.delete(key: key);

  Future<bool> containsKey(String key) async => _storage.containsKey(key: key);

  Future<void> clearAll() async {
    _cachedToken = null;
    _cachedRole = null;
    _cachedUserId = null;
    _cachedUserData = null;
    await _storage.deleteAll();
  }
}
