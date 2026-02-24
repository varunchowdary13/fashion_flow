import 'package:equatable/equatable.dart';

/// Base failure class for handling errors in the domain layer.
/// Uses functional error handling pattern with fpdart Either.
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server-side failures (API errors, network issues)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Cache/local storage failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Validation failures (form input errors)
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code,
  });
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code,
  });
}
