// lib/core/error/failures.dart

import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error. Please try again.']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Unauthorized. Admin access only.',
  ]);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local data error.']);
}

final class UploadFailure extends Failure {
  const UploadFailure([super.message = 'Upload failed. Please try again.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
