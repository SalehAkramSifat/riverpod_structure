import 'package:dio/dio.dart';
import 'package:riverpod_structure/core/storage/secure_storage_service.dart';

/// Interceptor that attaches the Bearer token automatically to every request
/// and handles 401 Unauthorized responses.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  static void Function()? onUnauthorized;

  AuthInterceptor({SecureStorageService? storage})
      : _storage = storage ?? SecureStorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // If request already has Authorization header, skip
    if (!options.headers.containsKey('Authorization')) {
      final token = _storage.token ?? SecureStorageService.currentToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _storage.clearAuthData();
      onUnauthorized?.call();
    }
    return handler.next(err);
  }
}
