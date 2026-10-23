import 'dart:io';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:dio/dio.dart' hide Response;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_structure/core/logging/logger.dart';
import 'package:riverpod_structure/core/models/response.dart';
import 'package:riverpod_structure/core/utils/app_urls.dart';

class Params {
  static const String page = 'page';
  static const String apiKey = 'api_key';
}

class NetworkCaller {
  late final Dio dio;

  static const Duration _defaultTimeout = Duration(seconds: 30);

  static String? authToken;
  static String? Function()? tokenProvider;

  static void clearToken() {
    authToken = null;
  }

  static void Function()? onUnauthorized;

  NetworkCaller({Dio? customDio}) {
    dio = customDio ?? Dio(_defaultBaseOptions);

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false, error: false),
      );
    }
  }

  BaseOptions get _defaultBaseOptions => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: _defaultTimeout,
    receiveTimeout: _defaultTimeout,
    sendTimeout: _defaultTimeout,
    headers: defaultHeaders,
    responseType: ResponseType.json,
  );

  String get baseUrl {
    try {
      return dotenv.env['BASE_URL'] ?? AppUrls.baseUrl;
    } catch (_) {
      return AppUrls.baseUrl;
    }
  }

  String get apiKey {
    try {
      return dotenv.env['API_KEY'] ?? '';
    } catch (_) {
      return '';
    }
  }

  Map<String, dynamic> get defaultHeaders => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> _buildHeaders({
    String? token,
    Map<String, dynamic>? extraHeaders,
    bool attachAuth = true,
  }) {
    final headers = Map<String, dynamic>.from(defaultHeaders);

    if (attachAuth) {
      final effectiveToken = token ?? tokenProvider?.call() ?? authToken;
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

  // 1️⃣ GET Request
  Future<ResponseData> getRequest(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    AppLogger.info('🌐 GET Request: $endpoint');
    final query = Map<String, dynamic>.from(queryParams ?? {});
    if (apiKey.isNotEmpty && !query.containsKey(Params.apiKey)) {
      query[Params.apiKey] = apiKey;
    }

    try {
      final response = await dio.get(
        endpoint,
        queryParameters: query,
        options: Options(
          headers: _buildHeaders(token: token, extraHeaders: headers),
        ),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      return _handleError(e, endpoint);
    }
  }

  Future<ResponseData> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) => getRequest(
    endpoint,
    queryParams: queryParams,
    headers: headers,
    token: token,
  );

  // 2️⃣ POST Request
  Future<ResponseData> postRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
    bool attachAuth = true,
  }) async {
    AppLogger.info('🚀 POST Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'POST Body');

    final query = Map<String, dynamic>.from(queryParams ?? {});
    if (apiKey.isNotEmpty && !query.containsKey(Params.apiKey)) {
      query[Params.apiKey] = apiKey;
    }

    try {
      final response = await dio.post(
        endpoint,
        data: body,
        queryParameters: query,
        options: Options(
          headers: _buildHeaders(
            token: token,
            extraHeaders: headers,
            attachAuth: attachAuth,
          ),
        ),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      return _handleError(e, endpoint);
    }
  }

  Future<ResponseData> post(
    String endpoint, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) => postRequest(
    endpoint,
    body: body ?? data,
    queryParams: queryParams,
    headers: headers,
    token: token,
  );

  Future<ResponseData> loginPostRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) => postRequest(
    endpoint,
    body: body,
    queryParams: queryParams,
    headers: headers,
    attachAuth: false,
  );

  // 3️⃣ PUT Request
  Future<ResponseData> putRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    AppLogger.info('🔄 PUT Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'PUT Body');

    try {
      final response = await dio.put(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(token: token, extraHeaders: headers),
        ),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      return _handleError(e, endpoint);
    }
  }

  Future<ResponseData> put(
    String endpoint, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) => putRequest(
    endpoint,
    body: body ?? data,
    queryParams: queryParams,
    headers: headers,
    token: token,
  );

  // 4️⃣ PATCH Request
  Future<ResponseData> patchRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    AppLogger.info('✏️ PATCH Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'PATCH Body');

    try {
      final response = await dio.patch(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(token: token, extraHeaders: headers),
        ),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      return _handleError(e, endpoint);
    }
  }

  Future<ResponseData> patch(
    String endpoint, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) => patchRequest(
    endpoint,
    body: body ?? data,
    queryParams: queryParams,
    headers: headers,
    token: token,
  );

  // 5️⃣ DELETE Request
  Future<ResponseData> deleteRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    AppLogger.info('🗑️ DELETE Request: $endpoint');

    try {
      final response = await dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(token: token, extraHeaders: headers),
        ),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      return _handleError(e, endpoint);
    }
  }

  Future<ResponseData> delete(
    String endpoint, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? token,
  }) => deleteRequest(
    endpoint,
    body: body ?? data,
    queryParams: queryParams,
    headers: headers,
    token: token,
  );

  // 6️⃣ MULTIPART File Upload Request
  Future<ResponseData> multipartRequest(
    String endpoint, {
    String method = 'POST',
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
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
          if (entry.value.existsSync()) {
            final fileName = entry.value.path
                .split(Platform.pathSeparator)
                .last;
            formData.files.add(
              MapEntry(
                entry.key,
                await MultipartFile.fromFile(
                  entry.value.path,
                  filename: fileName,
                ),
              ),
            );
          } else {
            AppLogger.warning(
              '⚠️ Multipart file not found: ${entry.value.path}',
            );
          }
        }
      }

      final requestHeaders = _buildHeaders(token: token, extraHeaders: headers)
        ..remove('Content-Type');

      final response = await dio.request(
        endpoint,
        data: formData,
        options: Options(method: method.toUpperCase(), headers: requestHeaders),
      );
      return _handleResponse(response, endpoint);
    } catch (e) {
      return _handleError(e, endpoint);
    }
  }

  Future<ResponseData> multipartPostRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, dynamic>? headers,
  }) => multipartRequest(
    endpoint,
    method: 'POST',
    fields: fields,
    files: files,
    token: token,
    headers: headers,
  );

  Future<ResponseData> multipartPatchRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, dynamic>? headers,
  }) => multipartRequest(
    endpoint,
    method: 'PATCH',
    fields: fields,
    files: files,
    token: token,
    headers: headers,
  );

  Future<ResponseData> multipartPutRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, dynamic>? headers,
  }) => multipartRequest(
    endpoint,
    method: 'PUT',
    fields: fields,
    files: files,
    token: token,
    headers: headers,
  );

  ResponseData _handleResponse(
    dio_pkg.Response<dynamic> response,
    String endpoint,
  ) {
    final statusCode = response.statusCode ?? 200;
    final data = response.data;

    if (statusCode >= 200 && statusCode < 300) {
      AppLogger.info('✅ Response [$statusCode]: $endpoint');
      if (kDebugMode && data != null) {
        AppLogger.json(data, tag: 'Response [$statusCode]');
      }
      return ResponseData.success(
        data: data,
        statusCode: statusCode,
        message: response.statusMessage ?? '',
      );
    }

    final errorMessage = _extractErrorMessage(
      data,
      'Request failed with status code $statusCode',
    );

    if (statusCode == 401) {
      AppLogger.warning('🔒 Response [401 Unauthorized]: $endpoint');
      onUnauthorized?.call();
      return ResponseData.error(
        message: errorMessage.isNotEmpty
            ? errorMessage
            : 'Session expired. Please log in again.',
        statusCode: 401,
        data: data,
      );
    }

    if (statusCode == 403) {
      AppLogger.warning('🚫 Response [403 Forbidden]: $endpoint');
      return ResponseData.error(
        message: errorMessage.isNotEmpty ? errorMessage : 'Access denied.',
        statusCode: 403,
        data: data,
      );
    }

    AppLogger.error('⚠️ Response [$statusCode]: $endpoint - $errorMessage');
    return ResponseData.error(
      message: errorMessage,
      statusCode: statusCode,
      data: data,
    );
  }

  ResponseData _handleError(dynamic error, String endpoint) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode ?? 0;
      final responseData = error.response?.data;
      final serverMessage = _extractErrorMessage(responseData, '');

      if (kDebugMode && responseData != null) {
        AppLogger.json(responseData, tag: 'Error Response [$statusCode]');
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          AppLogger.error('⏱️ ❌ Network Timeout: $endpoint', tag: 'Network');
          return ResponseData.error(
            message:
                'Request timed out. Please check your internet connection.',
            statusCode: 408,
            data: responseData,
          );

        case DioExceptionType.connectionError:
          AppLogger.error(
            '🔌 ❌ Network Connection Error: $endpoint',
            tag: 'Network',
          );
          return ResponseData.error(
            message: 'No internet connection. Please verify your network.',
            statusCode: 0,
            data: responseData,
          );

        case DioExceptionType.badResponse:
          if (statusCode == 401) {
            AppLogger.warning(
              '🔒 Response [401 Unauthorized]: $endpoint',
              tag: 'Network',
            );
            onUnauthorized?.call();
            return ResponseData.error(
              message: serverMessage.isNotEmpty
                  ? serverMessage
                  : 'Session expired. Please log in again.',
              statusCode: 401,
              data: responseData,
            );
          }

          if (statusCode == 403) {
            AppLogger.warning(
              '🚫 Response [403 Forbidden]: $endpoint',
              tag: 'Network',
            );
            return ResponseData.error(
              message: serverMessage.isNotEmpty
                  ? serverMessage
                  : 'You do not have permission to access this resource.',
              statusCode: 403,
              data: responseData,
            );
          }

          if (statusCode == 404) {
            final msg = serverMessage.isNotEmpty
                ? serverMessage
                : 'Requested resource not found (404).';
            AppLogger.warning(
              '🔍 Response [404 Not Found]: $endpoint - $msg',
              tag: 'Network',
            );
            return ResponseData.error(
              message: msg,
              statusCode: 404,
              data: responseData,
            );
          }

          if (statusCode == 500) {
            final msg = serverMessage.isNotEmpty
                ? serverMessage
                : 'Internal server error (500). Please try again later.';
            AppLogger.error(
              '💥 Response [500 Server Error]: $endpoint - $msg',
              tag: 'Network',
            );
            return ResponseData.error(
              message: msg,
              statusCode: 500,
              data: responseData,
            );
          }

          if (statusCode == 502 || statusCode == 503 || statusCode == 504) {
            final msg = serverMessage.isNotEmpty
                ? serverMessage
                : 'Server is currently unavailable or under maintenance ($statusCode). Please try again shortly.';
            AppLogger.error(
              '🚧 Response [$statusCode Server Unavailable]: $endpoint',
              tag: 'Network',
            );
            return ResponseData.error(
              message: msg,
              statusCode: statusCode,
              data: responseData,
            );
          }

          AppLogger.error(
            '⚠️ Response [$statusCode]: $endpoint - $serverMessage',
            tag: 'Network',
          );
          return ResponseData.error(
            message: serverMessage.isNotEmpty
                ? serverMessage
                : 'Request failed with status code $statusCode',
            statusCode: statusCode,
            data: responseData,
          );

        case DioExceptionType.cancel:
          return ResponseData.error(
            message: 'Request was cancelled',
            statusCode: 0,
          );

        case DioExceptionType.unknown:
        default:
          if (error.error is SocketException) {
            AppLogger.error('🔌 ❌ Socket Exception: $endpoint', tag: 'Network');
            return ResponseData.error(
              message: 'No internet connection. Please verify your network.',
              statusCode: 0,
            );
          }
          final fallbackMsg = serverMessage.isNotEmpty
              ? serverMessage
              : (error.message ?? 'An unexpected network error occurred');
          return ResponseData.error(
            message: fallbackMsg,
            statusCode: statusCode,
            data: responseData,
          );
      }
    } else if (error is SocketException) {
      AppLogger.error('🔌 ❌ Socket Exception: $endpoint', tag: 'Network');
      return ResponseData.error(
        message: 'No internet connection. Please verify your network.',
        statusCode: 0,
      );
    } else {
      AppLogger.error(
        '💥 ❌ Unexpected Error: $error at $endpoint',
        tag: 'Network',
      );
      return ResponseData.error(message: error.toString(), statusCode: 0);
    }
  }

  String _extractErrorMessage(dynamic data, String defaultMessage) {
    if (data == null) return defaultMessage;

    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
      if (data['errors'] != null) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) return first.first.toString();
          return first.toString();
        } else if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
        return errors.toString();
      }
    } else if (data is String) {
      final trimmed = data.trim();
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
}

// Convenient Aliases
typedef NetworkService = NetworkCaller;
typedef DioNetworkService = NetworkCaller;

// =============================================================================
// 💡 HOW TO USE NetworkCaller (EXAMPLES)
// =============================================================================
/*
// -----------------------------------------------------------------------------
// ১. গ্লোবাল কনফিগারেশন (main.dart অথবা App Init এ):
// -----------------------------------------------------------------------------
void initApp() {
  // টোকেন সেট করা (লগইনের পর):
  NetworkCaller.authToken = 'eyJhbGciOi...';

  // অথবা রিভারপড / লোকাল স্টোরেজ থেকে ডাইনামিক টোকেন:
  // NetworkCaller.tokenProvider = () => ref.read(sharedPrefProvider).get('token');

  // সেশন এক্সপায়ার্ড হলে স্বয়ংক্রিয় রিডাইরেক্ট:
  NetworkCaller.onUnauthorized = () {
    NetworkCaller.clearToken();
    rootNavigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  };
}

// -----------------------------------------------------------------------------
// ২. GET Request Example (অটো টোকেন যুক্ত হবে):
// -----------------------------------------------------------------------------
Future<void> fetchProfile() async {
  final response = await NetworkCaller().getRequest(AppUrls.nowShowing);
  if (response.isSuccess && response.responseData != null) {
    final user = UserModel.fromJson(response.responseData);
    // do something with user
  } else {
    AppLogger.error(response.errorMessage);
  }
}

// -----------------------------------------------------------------------------
// ৩. POST Request Example (Login / Forget Password - টোকেন ছাড়া):
// -----------------------------------------------------------------------------
Future<void> submitLogin(String email, String password) async {
  final response = await NetworkCaller().loginPostRequest(
    AppUrls.forgetPassword,
    body: {'email': email, 'password': password},
  );

  if (response.isSuccess) {
    final token = response.responseData['token'];
    NetworkCaller.authToken = token; // সেভ হয়ে গেল
    AppLogger.info('Logged in successfully!');
  } else {
    AppLogger.error(response.errorMessage);
  }
}

// -----------------------------------------------------------------------------
// ৪. Multipart POST Request (Image Upload):
// -----------------------------------------------------------------------------
Future<void> uploadAvatar(File imageFile) async {
  final response = await NetworkCaller().multipartPostRequest(
    '/user/upload-avatar',
    fields: {'userId': '123'},
    files: [MapEntry('avatar', imageFile)],
  );

  if (response.isSuccess) {
    AppLogger.info('Uploaded avatar successfully!');
  } else {
    AppLogger.error(response.errorMessage);
  }
}
*/
