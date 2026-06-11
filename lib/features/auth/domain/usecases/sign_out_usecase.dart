// lib/features/auth/domain/usecases/sign_out_usecase.dart

import '../../../../core/error/failures.dart';
import '../repositories/admin_auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignOutUseCase {
  final AdminAuthRepository _repository;
  const SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.signOut();
}
