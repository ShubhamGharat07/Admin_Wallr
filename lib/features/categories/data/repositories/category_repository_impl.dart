// lib/features/categories/data/repositories/category_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource _dataSource;
  const CategoryRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final list = await _dataSource.getCategories();
      return Right(list);
    } catch (e, stackTrace) {
      AppLogger.error('getCategories failed', error: e, stackTrace: stackTrace, tag: 'CategoryRepository');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleActive(String id, bool value) async {
    try {
      await _dataSource.toggleActive(id, value);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('toggleActive failed for id: $id', error: e, stackTrace: stackTrace, tag: 'CategoryRepository');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> togglePremium(String id, bool value) async {
    try {
      await _dataSource.togglePremium(id, value);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('togglePremium failed for id: $id', error: e, stackTrace: stackTrace, tag: 'CategoryRepository');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _dataSource.deleteCategory(id);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('deleteCategory failed for id: $id', error: e, stackTrace: stackTrace, tag: 'CategoryRepository');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateSortOrder(List<String> orderedIds) async {
    try {
      await _dataSource.updateSortOrder(orderedIds);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('updateSortOrder failed', error: e, stackTrace: stackTrace, tag: 'CategoryRepository');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(Map<String, dynamic> data) async {
    try {
      await _dataSource.addCategory(data);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('addCategory failed with data: $data', error: e, stackTrace: stackTrace, tag: 'CategoryRepository');
      return const Left(ServerFailure());
    }
  }
}

