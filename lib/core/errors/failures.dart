import 'package:equatable/equatable.dart';

/// Base Failure class used by domain, repositories, and presentation layers.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Something went wrong on the server. Please try again.',
    super.statusCode,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please verify your network.',
    super.statusCode = 0,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load local data.',
    super.statusCode,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please log in again.',
    super.statusCode = 401,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.statusCode,
  });
}
