import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/errors/exceptions.dart';
import 'package:riverpod_structure/core/models/response.dart' hide Response;
import 'package:riverpod_structure/core/network/dio_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

/// A clean, robust network client wrapping [Dio] with typed exception handling.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // GET
  Future<ResponseData> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  // POST
  Future<ResponseData> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  // PUT
  Future<ResponseData> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  // PATCH
  Future<ResponseData> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  // DELETE
  Future<ResponseData> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _execute(
      () => _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  // Multipart File Upload
  Future<ResponseData> uploadFile(
    String endpoint, {
    required File file,
    required String fileKey,
    Map<String, dynamic>? extraData,
    ProgressCallback? onSendProgress,
  }) async {
    final fileName = file.path.split('/').last.split('\\').last;
    final formData = FormData.fromMap({
      fileKey: await MultipartFile.fromFile(file.path, filename: fileName),
      if (extraData != null) ...extraData,
    });

    return _execute(
      () => _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      ),
    );
  }

  // Core execution and error mapping
  Future<ResponseData> _execute(Future<Response> Function() request) async {
    try {
      final response = await request();
      return ResponseData.success(
        statusCode: response.statusCode ?? 200,
        responseData: response.data,
        message: response.statusMessage ?? 'Success',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException(message: e.toString(), statusCode: 0, identifier: 'UNKNOWN');
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(message: 'Connection timed out. Please check your internet.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 500;
        final data = error.response?.data;
        String message = error.message ?? 'Server error occurred.';

        if (data is Map && data.containsKey('message')) {
          message = data['message'].toString();
        }

        if (statusCode == 401) {
          return UnauthorizedException(message: message, statusCode: 401);
        }
        return ServerException(message: message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return AppException(message: 'Request was cancelled.', statusCode: -1, identifier: 'CANCELLED');
      default:
        return AppException(
          message: error.message ?? 'An unexpected network error occurred.',
          statusCode: error.response?.statusCode,
          identifier: 'DIO_UNKNOWN',
        );
    }
  }
}

/// Convenient alias if you prefer the [NetworkCaller] naming convention.
typedef NetworkCaller = ApiClient;

/// Provider alias for [apiClientProvider].
final networkCallerProvider = apiClientProvider;

