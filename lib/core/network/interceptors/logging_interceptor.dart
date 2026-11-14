import 'package:dio/dio.dart';
import 'package:riverpod_structure/core/logging/logger.dart';

/// Interceptor that plugs into [AppLogger] to provide standardized,
/// readable network request & response logs.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.logRequest(
      options.method,
      options.uri.toString(),
      body: options.data,
    );
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.logResponse(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode ?? 200,
      data: response.data,
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.logNetworkError(
      err.requestOptions.method,
      err.requestOptions.uri.toString(),
      error: err.message ?? err.toString(),
      statusCode: err.response?.statusCode,
    );
    return handler.next(err);
  }
}
