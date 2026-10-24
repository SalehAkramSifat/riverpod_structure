import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/logging/logger.dart';
import 'package:riverpod_structure/core/models/response.dart' hide Response;
import 'package:riverpod_structure/core/services/auth_service.dart';
import 'package:riverpod_structure/core/services/network_controller.dart';
import 'package:riverpod_structure/core/utils/app_urls.dart';

class Params {
  static const String page = 'page';
  static const String apiKey = 'api_key';
}

/// Clean, short, and production-ready HTTP Network Caller powered by [Dio].
class NetworkCaller {
  static const Duration _timeout = Duration(seconds: 30);

  final Dio _dio;

  static String? authToken;
  static String? Function()? tokenProvider;
  static void Function()? onUnauthorized;

  static void clearToken() => authToken = null;
  static bool get isOffline => !NetworkController.isConnectedNow;

  static ResponseData get _offlineResponse => ResponseData.error(
        message: 'No internet connection. Please verify your network.',
        statusCode: 0,
      );

  NetworkCaller({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppUrls.baseUrl,
                connectTimeout: _timeout,
                receiveTimeout: _timeout,
                sendTimeout: _timeout,
                validateStatus: (status) => true, // Manual status validation for clean handling
                responseType: ResponseType.json,
              ),
            );

  // 1️⃣ GET Request
  Future<ResponseData> getRequest(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    String? token,
    Map<String, String>? headers,
  }) async {
    if (isOffline) return _offlineResponse;
    AppLogger.info('🌐 GET Request: $endpoint');

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(token: token, extraHeaders: headers),
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 2️⃣ POST Request
  Future<ResponseData> postRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    String? token,
    Map<String, String>? headers,
    bool attachAuth = true,
  }) async {
    if (isOffline) return _offlineResponse;
    AppLogger.info('🚀 POST Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'POST Request');

    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(
            token: token,
            extraHeaders: headers,
            attachAuth: attachAuth,
          ),
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 3️⃣ PUT Request
  Future<ResponseData> putRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    String? token,
    Map<String, String>? headers,
  }) async {
    if (isOffline) return _offlineResponse;
    AppLogger.info('🔄 PUT Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'PUT Request');

    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(token: token, extraHeaders: headers),
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 4️⃣ PATCH Request
  Future<ResponseData> patchRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    String? token,
    Map<String, String>? headers,
  }) async {
    if (isOffline) return _offlineResponse;
    AppLogger.info('✏️ PATCH Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'PATCH Request');

    try {
      final response = await _dio.patch(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(token: token, extraHeaders: headers),
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 5️⃣ DELETE Request
  Future<ResponseData> deleteRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    String? token,
    Map<String, String>? headers,
  }) async {
    if (isOffline) return _offlineResponse;
    AppLogger.info('🗑️ DELETE Request: $endpoint');

    try {
      final response = await _dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(token: token, extraHeaders: headers),
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 6️⃣ MULTIPART File Upload Request
  Future<ResponseData> multipartRequest(
    String endpoint, {
    String method = 'POST',
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
  }) async {
    if (isOffline) return _offlineResponse;
    AppLogger.info('📦 $method Multipart Request: $endpoint');

    try {
      final formData = FormData();

      if (fields != null) {
        fields.forEach((key, value) {
          if (value != null) {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });
      }

      if (files != null) {
        for (final entry in files) {
          final file = entry.value;
          final fileName = file.path.split(Platform.pathSeparator).last;
          formData.files.add(
            MapEntry(
              entry.key,
              await MultipartFile.fromFile(file.path, filename: fileName),
            ),
          );
        }
      }

      final requestHeaders = _buildHeaders(token: token, extraHeaders: headers)
        ..remove('Content-Type');

      final response = await _dio.request(
        endpoint,
        data: formData,
        options: Options(
          method: method,
          headers: requestHeaders,
        ),
        onSendProgress: onSendProgress,
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Alias for multipart POST request
  Future<ResponseData> multipartPostRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
  }) =>
      multipartRequest(
        endpoint,
        method: 'POST',
        fields: fields,
        files: files,
        token: token,
        headers: headers,
        onSendProgress: onSendProgress,
      );

  // ================= Private Helpers =================

  Map<String, String> _buildHeaders({
    String? token,
    Map<String, String>? extraHeaders,
    bool attachAuth = true,
  }) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (attachAuth) {
      final activeToken = token ??
          authToken ??
          tokenProvider?.call() ??
          AuthService.token;

      if (activeToken != null && activeToken.trim().isNotEmpty) {
        headers['Authorization'] = activeToken.startsWith('Bearer ')
            ? activeToken
            : 'Bearer $activeToken';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  ResponseData _handleResponse(Response response) {
    final statusCode = response.statusCode ?? 500;
    final dynamic data = response.data;

    AppLogger.info('📥 Status: $statusCode');

    if (statusCode >= 200 && statusCode < 300) {
      return ResponseData.success(
        responseData: data,
        statusCode: statusCode,
      );
    }

    if (statusCode == 401) {
      AppLogger.warning('🔒 Unauthorized (401). Triggering session expiration.');
      onUnauthorized?.call();
      return ResponseData.error(
        message: _extractErrorMessage(data) ??
            'Session expired. Please log in again.',
        statusCode: 401,
        responseData: data,
      );
    }

    final errorMessage = _extractErrorMessage(data) ??
        'Request failed with status $statusCode';

    AppLogger.error('❌ API Error: $errorMessage (Code: $statusCode)');
    return ResponseData.error(
      message: errorMessage,
      statusCode: statusCode,
      responseData: data,
    );
  }

  ResponseData _handleError(dynamic error) {
    if (error is DioException) {
      AppLogger.error('❌ DioException: [${error.type}] ${error.message}');
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ResponseData.error(
            message:
                'Request timed out. Please check your internet connection.',
            statusCode: 408,
          );
        case DioExceptionType.connectionError:
          return ResponseData.error(
            message: 'No internet connection. Please verify your network.',
            statusCode: 0,
          );
        case DioExceptionType.badCertificate:
          return ResponseData.error(
            message: 'Security certificate error. Please try again later.',
            statusCode: 495,
          );
        case DioExceptionType.cancel:
          return ResponseData.error(
            message: 'Request was cancelled.',
            statusCode: 499,
          );
        case DioExceptionType.badResponse:
          if (error.response != null) {
            return _handleResponse(error.response!);
          }
          return ResponseData.error(
            message: 'Server returned an invalid response.',
            statusCode: error.response?.statusCode ?? 500,
          );
        case DioExceptionType.transformTimeout:
          return ResponseData.error(
            message: 'Data processing timed out. Please try again.',
            statusCode: 408,
          );
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return ResponseData.error(
              message: 'No internet connection. Please verify your network.',
              statusCode: 0,
            );
          }
          return ResponseData.error(
            message:
                'An unexpected network error occurred. Please try again.',
            statusCode: 500,
          );
      }
    }

    if (error is SocketException) {
      return ResponseData.error(
        message: 'No internet connection. Please verify your network.',
        statusCode: 0,
      );
    }

    AppLogger.error('💥 Unexpected Network Error: $error');
    return ResponseData.error(
      message: 'An unexpected error occurred. Please try again.',
      statusCode: 500,
    );
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.startsWith('<!DOCTYPE html>') ||
          trimmed.startsWith('<html') ||
          trimmed.contains('<body')) {
        return 'Server error occurred. Please try again later.';
      }
      return trimmed.isNotEmpty ? trimmed : null;
    }

    if (data is Map) {
      final messageKeys = [
        'message',
        'error',
        'errorMessage',
        'msg',
        'detail',
        'status_message',
      ];
      for (final key in messageKeys) {
        if (data.containsKey(key) && data[key] != null) {
          final val = data[key];
          if (val is String && val.trim().isNotEmpty) return val.trim();
          if (val is List && val.isNotEmpty) return val.first.toString();
        }
      }

      if (data.containsKey('errors') && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final firstError = errors.values.firstOrNull;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        if (firstError != null) return firstError.toString();
      }
    }

    return null;
  }
}

typedef NetworkService = NetworkCaller;
typedef DioNetworkService = NetworkCaller;

/// Global Riverpod provider for [NetworkCaller]
final networkServiceProvider = Provider<NetworkCaller>((ref) {
  return NetworkCaller();
});
