import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/core/models/response.dart';

class AppException implements Exception {
  final String? message;
  final int? statusCode;
  final String? identifier;
  final String? which;

  AppException({
    required this.message,
    required this.statusCode,
    required this.identifier,
    this.which,
  });

  @override
  String toString() {
    return 'AppException{message: $message, statusCode: $statusCode, identifier: $identifier, which: $which}';
  }
}

extension HttpExceptionExtension on AppException {
  Left<AppException, Response> get toLeft => Left<AppException, Response>(this);
}
