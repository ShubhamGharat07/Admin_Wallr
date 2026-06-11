// lib/features/categories/presentation/bloc/category_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallr_admin/features/categories/domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repository;

  CategoryBloc(this._repository) : super(const CategoryInitial()) {
    on<CategoriesLoadRequested>(_onLoad);
    on<CategoryActiveToggled>(_onToggleActive);
    on<CategoryPremiumToggled>(_onTogglePremium);
    on<CategoryDeleteRequested>(_onDelete);
    on<CategorySortOrderUpdated>(_onSortOrder);
  }

  Future<void> _onLoad(CategoriesLoadRequested e, Emitter emit) async {
    emit(const CategoryLoading());
    final result = await _repository.getCategories();
    result.fold(
      (f) => emit(CategoryError(f.message)),
      (list) => emit(CategoryLoaded(list)),
    );
  }

  Future<void> _onToggleActive(CategoryActiveToggled e, Emitter emit) async {
    if (state is! CategoryLoaded) return;
    final current = (state as CategoryLoaded).categories;
    // Optimistic update
    final updated = current.map((c) {
      if (c.id == e.id) {
        return CategoryEntity(
          id: c.id,
          name: c.name,
          slug: c.slug,
          iconName: c.iconName,
          accentColor: c.accentColor,
          wallpaperCount: c.wallpaperCount,
          isPremium: c.isPremium,
          isActive: e.value,
          sortOrder: c.sortOrder,
        );
      }
      return c;
    }).toList();
    emit(CategoryLoaded(updated));
    await _repository.toggleActive(e.id, e.value);
  }

  Future<void> _onTogglePremium(CategoryPremiumToggled e, Emitter emit) async {
    if (state is! CategoryLoaded) return;
    final current = (state as CategoryLoaded).categories;
    final updated = current.map((c) {
      if (c.id == e.id) {
        return CategoryEntity(
          id: c.id,
          name: c.name,
          slug: c.slug,
          iconName: c.iconName,
          accentColor: c.accentColor,
          wallpaperCount: c.wallpaperCount,
          isPremium: e.value,
          isActive: c.isActive,
          sortOrder: c.sortOrder,
        );
      }
      return c;
    }).toList();
    emit(CategoryLoaded(updated));
    await _repository.togglePremium(e.id, e.value);
  }

  Future<void> _onDelete(CategoryDeleteRequested e, Emitter emit) async {
    if (state is! CategoryLoaded) return;
    final current = (state as CategoryLoaded).categories;
    emit(CategoryLoaded(current.where((c) => c.id != e.id).toList()));
    await _repository.deleteCategory(e.id);
  }

  Future<void> _onSortOrder(CategorySortOrderUpdated e, Emitter emit) async {
    await _repository.updateSortOrder(e.orderedIds);
  }
}
