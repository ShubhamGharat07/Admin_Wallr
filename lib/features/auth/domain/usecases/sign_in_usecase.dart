// lib/features/auth/domain/usecases/sign_in_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_auth_repository.dart';

class SignInParams {
  final String email;
  final String password;
  const SignInParams({required this.email, required this.password});
}

class SignInUseCase {
  final AdminAuthRepository _repository;
  const SignInUseCase(this._repository);

  Future<Either<Failure, AdminUserEntity>> call(SignInParams params) =>
      _repository.signIn(params.email, params.password);
}
