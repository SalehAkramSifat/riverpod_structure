import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

class ResponseData {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String message;

  ResponseData({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.message = '',
  });

  dynamic get data => responseData;

  String get errorMessage => message;

  String? get statusMessage => message.isNotEmpty ? message : null;

  factory ResponseData.success({
    dynamic data,
    dynamic responseData,
    int statusCode = 200,
    String message = '',
  }) {
    return ResponseData(
      isSuccess: true,
      statusCode: statusCode,
      responseData: data ?? responseData,
      message: message,
    );
  }

  factory ResponseData.error({
    required String message,
    int statusCode = 0,
    dynamic data,
    dynamic responseData,
  }) {
    return ResponseData(
      isSuccess: false,
      statusCode: statusCode,
      responseData: data ?? responseData,
      message: message,
    );
  }

  R fold<R>(
    R Function(AppException failure) onFailure,
    R Function(ResponseData success) onSuccess,
  ) {
    if (isSuccess) {
      return onSuccess(this);
    } else {
      return onFailure(
        AppException(
          message: errorMessage,
          statusCode: statusCode,
          identifier: '',
          which: 'http',
        ),
      );
    }
  }

  @override
  String toString() {
    return 'ResponseData{isSuccess: $isSuccess, statusCode: $statusCode, errorMessage: $errorMessage, responseData: $responseData}';
  }
}

typedef Response = ResponseData;

extension ResponseExtension on ResponseData {
  Right<AppException, ResponseData> get toRight => Right(this);
}
