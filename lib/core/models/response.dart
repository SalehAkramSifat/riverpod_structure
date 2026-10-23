import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

class ResponseData {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String errorMessage;

  ResponseData({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage = '',
  });

  dynamic get data => responseData;

  String get message => errorMessage;

  String? get statusMessage => errorMessage.isNotEmpty ? errorMessage : null;

  factory ResponseData.success({
    required dynamic data,
    int statusCode = 200,
    String message = '',
  }) {
    return ResponseData(
      isSuccess: true,
      statusCode: statusCode,
      responseData: data,
      errorMessage: message,
    );
  }

  factory ResponseData.error({
    required String message,
    int statusCode = 0,
    dynamic data,
  }) {
    return ResponseData(
      isSuccess: false,
      statusCode: statusCode,
      responseData: data,
      errorMessage: message,
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
