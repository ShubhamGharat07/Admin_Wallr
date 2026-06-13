// lib/features/categories/presentation/bloc/category_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

final class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

final class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  const CategoryLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

final class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);
  @override
  List<Object?> get props => [message];
}

final class CategoryAdding extends CategoryState {
  const CategoryAdding();
}

final class CategoryAdded extends CategoryState {
  const CategoryAdded();
}
