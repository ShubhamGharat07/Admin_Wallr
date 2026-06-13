// lib/features/categories/presentation/bloc/category_event.dart

import 'package:equatable/equatable.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object> get props => [];
}

final class CategoriesLoadRequested extends CategoryEvent {
  const CategoriesLoadRequested();
}

final class CategoryActiveToggled extends CategoryEvent {
  final String id;
  final bool value;
  const CategoryActiveToggled({required this.id, required this.value});
  @override
  List<Object> get props => [id, value];
}

final class CategoryPremiumToggled extends CategoryEvent {
  final String id;
  final bool value;
  const CategoryPremiumToggled({required this.id, required this.value});
  @override
  List<Object> get props => [id, value];
}

final class CategoryDeleteRequested extends CategoryEvent {
  final String id;
  const CategoryDeleteRequested(this.id);
  @override
  List<Object> get props => [id];
}

final class CategorySortOrderUpdated extends CategoryEvent {
  final List<String> orderedIds;
  const CategorySortOrderUpdated(this.orderedIds);
  @override
  List<Object> get props => [orderedIds];
}

final class CategoryAddRequested extends CategoryEvent {
  final String name;
  final String slug;
  final String iconName;
  final bool isPremium;
  final bool isActive;
  final List<int>? coverImageBytes;
  final String? coverImageFileName;

  const CategoryAddRequested({
    required this.name,
    required this.slug,
    required this.iconName,
    required this.isPremium,
    required this.isActive,
    this.coverImageBytes,
    this.coverImageFileName,
  });

  @override
  List<Object> get props => [name, slug, iconName, isPremium, isActive];
}
