// lib/features/auth/domain/repositories/admin_auth_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin_user_entity.dart';

abstract interface class AdminAuthRepository {
  Future<Either<Failure, AdminUserEntity>> signIn(
    String email,
    String password,
  );
  Future<Either<Failure, void>> signOut();
  AdminUserEntity? getCurrentUser();
}
