import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/core/models/response.dart';

/// Base class for all application exceptions.
class AppException implements Exception {
  final String? message;
  final int? statusCode;
  final String? identifier;
  final String? which;

  AppException({
    this.message,
    this.statusCode,
    this.identifier,
    this.which,
  });

  @override
  String toString() {
    return 'AppException{message: $message, statusCode: $statusCode, identifier: $identifier, which: $which}';
  }
}

/// Thrown when a remote server returns an error response (e.g. 4xx, 5xx).
class ServerException extends AppException {
  ServerException({
    super.message = 'A server error occurred. Please try again.',
    super.statusCode,
    super.identifier,
  }) : super(which: 'server');
}

/// Thrown when there is no internet connection or network timeouts occur.
class NetworkException extends AppException {
  NetworkException({
    super.message = 'No internet connection. Please verify your network.',
    super.statusCode = 0,
    super.identifier,
  }) : super(which: 'network');
}

/// Thrown when local cache or storage read/write operations fail.
class CacheException extends AppException {
  CacheException({
    super.message = 'Failed to read or write local cache.',
    super.statusCode,
    super.identifier,
  }) : super(which: 'cache');
}

/// Thrown when an authentication or authorization failure occurs (401, 403).
class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Session expired or unauthorized. Please log in again.',
    super.statusCode = 401,
    super.identifier,
  }) : super(which: 'auth');
}

extension HttpExceptionExtension on AppException {
  Left<AppException, Response> get toLeft => Left<AppException, Response>(this);
}
