// lib/core/error/exceptions.dart

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error.']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}

class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException({this.message = 'Authentication failed.', this.code});
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([
    this.message = 'Unauthorized. Admin access only.',
  ]);
}

class UploadException implements Exception {
  final String message;
  const UploadException([this.message = 'Upload failed.']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Resource not found.']);
}
