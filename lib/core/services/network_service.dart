import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_structure/core/logging/logger.dart';
import 'package:riverpod_structure/core/models/response.dart';
import 'package:riverpod_structure/core/services/auth_service.dart';
import 'package:riverpod_structure/core/services/network_controller.dart';
import 'package:riverpod_structure/core/utils/app_urls.dart';

class Params {
  static const String page = 'page';
  static const String apiKey = 'api_key';
}

class NetworkCaller {
  static const Duration _timeout = Duration(seconds: 30);

  static String? authToken;
  static String? Function()? tokenProvider;
  static void Function()? onUnauthorized;

  static void clearToken() => authToken = null;

  static bool get isOffline => !NetworkController.isConnectedNow;

  static ResponseData get _offlineResponse => ResponseData.error(
        message: 'No internet connection. Please verify your network.',
        statusCode: 0,
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
      final uri = _buildUri(endpoint, queryParams);
      final response = await http
          .get(
            uri,
            headers: _buildHeaders(token: token, extraHeaders: headers),
          )
          .timeout(_timeout);
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
      final uri = _buildUri(endpoint, queryParams);
      final response = await http
          .post(
            uri,
            headers: _buildHeaders(
              token: token,
              extraHeaders: headers,
              attachAuth: attachAuth,
            ),
            body: body != null
                ? (body is String ? body : jsonEncode(body))
                : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> loginPostRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) {
    return postRequest(
      endpoint,
      body: body,
      queryParams: queryParams,
      headers: headers,
      attachAuth: false,
    );
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
      final uri = _buildUri(endpoint, queryParams);
      final response = await http
          .put(
            uri,
            headers: _buildHeaders(token: token, extraHeaders: headers),
            body: body != null
                ? (body is String ? body : jsonEncode(body))
                : null,
          )
          .timeout(_timeout);
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
      final uri = _buildUri(endpoint, queryParams);
      final response = await http
          .patch(
            uri,
            headers: _buildHeaders(token: token, extraHeaders: headers),
            body: body != null
                ? (body is String ? body : jsonEncode(body))
                : null,
          )
          .timeout(_timeout);
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
      final uri = _buildUri(endpoint, queryParams);
      final response = await http
          .delete(
            uri,
            headers: _buildHeaders(token: token, extraHeaders: headers),
            body: body != null
                ? (body is String ? body : jsonEncode(body))
                : null,
          )
          .timeout(_timeout);
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
  }) async {
    if (isOffline) return _offlineResponse;
    AppLogger.info('📦 $method Multipart Request: $endpoint');
    try {
      final uri = _buildUri(endpoint);
      final request = http.MultipartRequest(method, uri);

      final requestHeaders = _buildHeaders(token: token, extraHeaders: headers)
        ..remove('Content-Type');
      request.headers.addAll(requestHeaders);

      if (fields != null) {
        fields.forEach((key, value) {
          if (value != null) {
            request.fields[key] = value is Map || value is List
                ? jsonEncode(value)
                : value.toString();
          }
        });
      }

      if (files != null) {
        for (final entry in files) {
          if (entry.value.existsSync()) {
            request.files.add(
              await http.MultipartFile.fromPath(entry.key, entry.value.path),
            );
          } else {
            AppLogger.warning(
              '⚠️ Multipart File not found: ${entry.value.path}',
            );
          }
        }
      }

      final streamedResponse = await request.send().timeout(_timeout * 2);
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> multipartPostRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
  }) {
    return multipartRequest(
      endpoint,
      method: 'POST',
      fields: fields,
      files: files,
      token: token,
      headers: headers,
    );
  }

  Future<ResponseData> multipartPatchRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
  }) {
    return multipartRequest(
      endpoint,
      method: 'PATCH',
      fields: fields,
      files: files,
      token: token,
      headers: headers,
    );
  }

  Future<ResponseData> multipartPutRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
  }) {
    return multipartRequest(
      endpoint,
      method: 'PUT',
      fields: fields,
      files: files,
      token: token,
      headers: headers,
    );
  }

  Future<ResponseData> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    String? token,
  }) => getRequest(
    endpoint,
    queryParams: queryParams,
    token: token,
    headers: headers,
  );

  Future<ResponseData> post(
    String endpoint, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    String? token,
  }) => postRequest(
    endpoint,
    body: body ?? data,
    queryParams: queryParams,
    token: token,
    headers: headers,
  );

  // Helpers & Handlers
  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    String url = endpoint;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      final base = AppUrls.baseUrl.endsWith('/')
          ? AppUrls.baseUrl
          : '${AppUrls.baseUrl}/';
      final path = url.startsWith('/') ? url.substring(1) : url;
      url = '$base$path';
    }

    final uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      final query = Map<String, String>.from(uri.queryParameters);
      queryParams.forEach((k, v) => query[k] = v.toString());
      return uri.replace(queryParameters: query);
    }
    return uri;
  }

  Map<String, String> _buildHeaders({
    String? token,
    Map<String, String>? extraHeaders,
    bool attachAuth = true,
  }) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (attachAuth) {
      final effectiveToken =
          token ?? AuthService.token ?? tokenProvider?.call() ?? authToken;
      if (effectiveToken != null && effectiveToken.trim().isNotEmpty) {
        headers['Authorization'] = effectiveToken.startsWith('Bearer ')
            ? effectiveToken
            : 'Bearer $effectiveToken';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  ResponseData _handleResponse(http.Response response) {
    final decoded = _safeDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      AppLogger.info(
        '✅ Response [${response.statusCode}]: ${response.request?.url ?? ''}',
      );
      return ResponseData.success(
        data: decoded,
        statusCode: response.statusCode,
        message: _extractSuccessMessage(decoded),
      );
    }

    if (response.statusCode == 401) {
      AppLogger.warning(
        '🔒 Response [401 Unauthorized]: ${response.request?.url ?? ''}',
      );
      onUnauthorized?.call();
      return ResponseData.error(
        message: _extractErrorMessage(
          decoded,
          'Your session has expired. Please log in again.',
        ),
        statusCode: 401,
        data: decoded,
      );
    }

    if (response.statusCode == 403) {
      AppLogger.warning(
        '🚫 Response [403 Forbidden]: ${response.request?.url ?? ''}',
      );
      return ResponseData.error(
        message: _extractErrorMessage(
          decoded,
          'You do not have permission to access this resource.',
        ),
        statusCode: 403,
        data: decoded,
      );
    }

    AppLogger.error(
      '⚠️ Response [${response.statusCode}]: ${response.request?.url ?? ''}',
    );
    return ResponseData.error(
      message: _extractErrorMessage(
        decoded,
        'Request failed with status code ${response.statusCode}.',
      ),
      statusCode: response.statusCode,
      data: decoded,
    );
  }

  dynamic _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _extractErrorMessage(dynamic decoded, String defaultMessage) {
    if (decoded is Map) {
      if (decoded['message'] != null) return decoded['message'].toString();
      if (decoded['error'] != null) return decoded['error'].toString();
      if (decoded['errors'] != null) {
        final err = decoded['errors'];
        if (err is Map && err.isNotEmpty) {
          final first = err.values.first;
          return (first is List && first.isNotEmpty)
              ? first.first.toString()
              : first.toString();
        } else if (err is List && err.isNotEmpty) {
          return err.first.toString();
        }
        return err.toString();
      }
    } else if (decoded is String) {
      final trimmed = decoded.trim();
      if (trimmed.startsWith('<') || trimmed.toLowerCase().contains('<html>')) {
        return defaultMessage;
      }
      if (trimmed.isNotEmpty) {
        return trimmed.length > 200
            ? '${trimmed.substring(0, 200)}...'
            : trimmed;
      }
    }
    return defaultMessage;
  }

  String _extractSuccessMessage(dynamic decoded) {
    if (decoded is Map && decoded['message'] != null) {
      return decoded['message'].toString();
    }
    return '';
  }

  ResponseData _handleError(dynamic error) {
    if (error is TimeoutException) {
      AppLogger.error('⏱️ ❌ Network Error (Timeout): $error');
      return ResponseData.error(
        message: 'Request timed out. Please check your internet connection.',
        statusCode: 408,
      );
    } else if (error is SocketException) {
      AppLogger.error('🔌 ❌ Network Error (No Internet): $error');
      return ResponseData.error(
        message: 'No internet connection. Please verify your network.',
        statusCode: 0,
      );
    } else if (error is http.ClientException) {
      AppLogger.error('📡 ❌ Network Error (Client Exception): $error');
      return ResponseData.error(
        message: 'Client communication error. Please try again.',
        statusCode: 500,
      );
    } else {
      AppLogger.error('💥 ❌ Network Error: $error');
      return ResponseData.error(
        message: 'An unexpected network error occurred. Please try again.',
        statusCode: 500,
      );
    }
  }
}

typedef NetworkService = NetworkCaller;
typedef DioNetworkService = NetworkCaller;

/// Global Riverpod provider for [NetworkCaller]
final networkServiceProvider = Provider<NetworkCaller>((ref) {
  return NetworkCaller();
});
