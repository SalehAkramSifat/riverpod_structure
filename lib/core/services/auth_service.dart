import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_structure/core/logging/logger.dart';
import 'package:riverpod_structure/routes/app_router.dart';

class AuthService {
  AuthService._();

  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static String? _token;
  static String? _role;
  static String? _userId;
  static Map<String, dynamic>? _userData;
  static bool _isInitialized = false;

  static Future<void> init() async {
    try {
      _token = await _storage.read(key: _tokenKey);
      _role = await _storage.read(key: _roleKey);
      _userId = await _storage.read(key: _userIdKey);

      final rawUserData = await _storage.read(key: _userDataKey);
      if (rawUserData != null && rawUserData.isNotEmpty) {
        _userData = jsonDecode(rawUserData) as Map<String, dynamic>;
      }

      _isInitialized = true;
      AppLogger.info('🔐 AuthService initialized securely.');
    } catch (e, stack) {
      AppLogger.error(
        'Failed to initialize AuthService',
        error: e,
        stackTrace: stack,
      );
    }
  }

  static bool hasToken() {
    return _token != null && _token!.trim().isNotEmpty;
  }

  static String? get token => _token;

  static String? get role => _role;

  static String? get userId => _userId;

  static Map<String, dynamic>? get userData => _userData;

  static bool get isInitialized => _isInitialized;

  static Future<void> saveToken(String token, {String? id}) async {
    try {
      _token = token;
      await _storage.write(key: _tokenKey, value: token);

      if (id != null) {
        _userId = id;
        await _storage.write(key: _userIdKey, value: id);
      }
      AppLogger.info('Auth token saved securely.');
    } catch (e, stack) {
      AppLogger.error(
        'Error saving auth token securely',
        error: e,
        stackTrace: stack,
      );
    }
  }

  static Future<void> saveRole(String role) async {
    try {
      _role = role;
      await _storage.write(key: _roleKey, value: role);
      AppLogger.info('Role saved securely: $role');
    } catch (e, stack) {
      AppLogger.error(
        'Error saving role securely',
        error: e,
        stackTrace: stack,
      );
    }
  }

  static Future<void> saveUserData(Map<String, dynamic> data) async {
    try {
      _userData = data;
      await _storage.write(key: _userDataKey, value: jsonEncode(data));
      AppLogger.info('User data saved securely.');
    } catch (e, stack) {
      AppLogger.error(
        'Error saving user data securely',
        error: e,
        stackTrace: stack,
      );
    }
  }

  static Future<void> logoutUser() async {
    try {
      _token = null;
      _role = null;
      _userId = null;
      _userData = null;
      await _storage.deleteAll();
      AppLogger.info('Logout: Secure credentials cleared.');
      await goToLogin();
    } catch (e, stack) {
      AppLogger.error('Error during logout', error: e, stackTrace: stack);
    }
  }

  static Future<void> goToLogin() async {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      context.go(AppRoute.home);
    }
  }
}
