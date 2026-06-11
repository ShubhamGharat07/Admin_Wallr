// lib/features/auth/data/repositories/admin_auth_repository_impl.dart

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/repositories/admin_auth_repository.dart';
import '../datasources/admin_auth_datasource.dart';
import 'package:dartz/dartz.dart';

class AdminAuthRepositoryImpl implements AdminAuthRepository {
  final AdminAuthDataSource _dataSource;
  final NetworkInfo _networkInfo;

  const AdminAuthRepositoryImpl({
    required AdminAuthDataSource dataSource,
    required NetworkInfo networkInfo,
  }) : _dataSource = dataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AdminUserEntity>> signIn(
    String email,
    String password,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final user = await _dataSource.signIn(email, password);
      return Right(user);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  AdminUserEntity? getCurrentUser() => _dataSource.getCurrentUser();
}
