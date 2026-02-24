/// Base exception class for app-specific exceptions.
abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Thrown when a server/API request fails.
class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

/// Thrown when authentication fails.
class AuthException extends AppException {
  const AuthException({required super.message, super.code});
}

/// Thrown when cache operations fail.
class CacheException extends AppException {
  const CacheException({required super.message, super.code});
}

/// Thrown when network is unavailable.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code,
  });
}

/// Thrown when a resource is not found.
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.code = 404,
  });
}
