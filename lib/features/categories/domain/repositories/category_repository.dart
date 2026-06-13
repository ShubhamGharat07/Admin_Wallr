// lib/features/categories/domain/repositories/category_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';

abstract interface class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, void>> toggleActive(String id, bool value);
  Future<Either<Failure, void>> togglePremium(String id, bool value);
  Future<Either<Failure, void>> deleteCategory(String id);
  Future<Either<Failure, void>> updateSortOrder(List<String> orderedIds);
  Future<Either<Failure, void>> addCategory(Map<String, dynamic> data);
}
