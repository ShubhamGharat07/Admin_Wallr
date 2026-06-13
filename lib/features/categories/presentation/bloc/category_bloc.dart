// // lib/features/categories/presentation/bloc/category_bloc.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wallr_admin/config/di/injection.dart';
// import 'package:wallr_admin/core/utils/cloudinary_service.dart';
// import 'package:wallr_admin/core/utils/logger.dart';
// import 'package:wallr_admin/features/categories/domain/entities/category_entity.dart';
// import '../../domain/repositories/category_repository.dart';
// import 'category_event.dart';
// import 'category_state.dart';

// class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
//   final CategoryRepository _repository;

//   CategoryBloc(this._repository) : super(const CategoryInitial()) {
//     on<CategoriesLoadRequested>(_onLoad);
//     on<CategoryActiveToggled>(_onToggleActive);
//     on<CategoryPremiumToggled>(_onTogglePremium);
//     on<CategoryDeleteRequested>(_onDelete);
//     on<CategorySortOrderUpdated>(_onSortOrder);
//     on<CategoryAddRequested>(_onAdd);
//   }

//   Future<void> _onLoad(CategoriesLoadRequested e, Emitter emit) async {
//     emit(const CategoryLoading());
//     final result = await _repository.getCategories();
//     result.fold(
//       (f) => emit(CategoryError(f.message)),
//       (list) => emit(CategoryLoaded(list)),
//     );
//   }

//   Future<void> _onToggleActive(CategoryActiveToggled e, Emitter emit) async {
//     if (state is! CategoryLoaded) return;
//     final current = (state as CategoryLoaded).categories;
//     // Optimistic update
//     final updated = current.map((c) {
//       if (c.id == e.id) {
//         return CategoryEntity(
//           id: c.id,
//           name: c.name,
//           slug: c.slug,
//           iconName: c.iconName,
//           accentColor: c.accentColor,
//           wallpaperCount: c.wallpaperCount,
//           isPremium: c.isPremium,
//           isActive: e.value,
//           sortOrder: c.sortOrder,
//         );
//       }
//       return c;
//     }).toList();
//     emit(CategoryLoaded(updated));
//     await _repository.toggleActive(e.id, e.value);
//   }

//   Future<void> _onTogglePremium(CategoryPremiumToggled e, Emitter emit) async {
//     if (state is! CategoryLoaded) return;
//     final current = (state as CategoryLoaded).categories;
//     final updated = current.map((c) {
//       if (c.id == e.id) {
//         return CategoryEntity(
//           id: c.id,
//           name: c.name,
//           slug: c.slug,
//           iconName: c.iconName,
//           accentColor: c.accentColor,
//           wallpaperCount: c.wallpaperCount,
//           isPremium: e.value,
//           isActive: c.isActive,
//           sortOrder: c.sortOrder,
//         );
//       }
//       return c;
//     }).toList();
//     emit(CategoryLoaded(updated));
//     await _repository.togglePremium(e.id, e.value);
//   }

//   Future<void> _onDelete(CategoryDeleteRequested e, Emitter emit) async {
//     if (state is! CategoryLoaded) return;
//     final current = (state as CategoryLoaded).categories;
//     emit(CategoryLoaded(current.where((c) => c.id != e.id).toList()));
//     await _repository.deleteCategory(e.id);
//   }

//   Future<void> _onSortOrder(CategorySortOrderUpdated e, Emitter emit) async {
//     await _repository.updateSortOrder(e.orderedIds);
//   }

//   Future<void> _onAdd(CategoryAddRequested e, Emitter emit) async {
//     emit(const CategoryAdding());

//     try {
//       String coverUrl = '';

//       // Upload cover image to Cloudinary if provided
//       if (e.coverImageBytes != null && e.coverImageFileName != null) {
//         final cloudinary = sl<CloudinaryService>();
//         final result = await cloudinary.uploadWallpaper(
//           fileBytes: e.coverImageBytes!,
//           fileName: e.coverImageFileName!,
//           onProgress: null,
//         );
//         coverUrl = result.secureUrl;
//       }

//       final data = {
//         'name': e.name,
//         'slug': e.slug,
//         'iconName': e.iconName,
//         'accentColor': '#F5C518',
//         'wallpaperCount': 0,
//         'isPremium': e.isPremium,
//         'isActive': e.isActive,
//         'coverUrl': coverUrl,
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       final result = await _repository.addCategory(data);
//       result.fold(
//         (f) {
//           AppLogger.error('Failed to add category: ${f.message}', tag: 'CategoryBloc');
//           emit(CategoryError(f.message));
//         },
//         (_) => emit(const CategoryAdded()),
//       );
//     } catch (err, stackTrace) {
//       AppLogger.error('Exception during addCategory in CategoryBloc', error: err, stackTrace: stackTrace, tag: 'CategoryBloc');
//       emit(CategoryError(err.toString()));
//     }
//   }
// }

// lib/features/categories/presentation/bloc/category_bloc.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/injection.dart';
import '../../../../core/utils/cloudinary_service.dart';
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
    on<CategoryAddRequested>(_onAdd);
  }

  // ── Load ──────────────────────────────────────────────────
  Future<void> _onLoad(CategoriesLoadRequested e, Emitter emit) async {
    emit(const CategoryLoading());
    final result = await _repository.getCategories();
    result.fold(
      (f) => emit(CategoryError(f.message)),
      (list) => emit(CategoryLoaded(list)),
    );
  }

  // ── Toggle Active ─────────────────────────────────────────
  Future<void> _onToggleActive(CategoryActiveToggled e, Emitter emit) async {
    if (state is! CategoryLoaded) return;
    final current = (state as CategoryLoaded).categories;

    // Optimistic update
    emit(
      CategoryLoaded(
        current
            .map((c) => c.id == e.id ? c.copyWith(isActive: e.value) : c)
            .toList(),
      ),
    );

    // Firestore — revert on fail
    final result = await _repository.toggleActive(e.id, e.value);
    result.fold(
      (f) => emit(
        CategoryLoaded(
          current
              .map((c) => c.id == e.id ? c.copyWith(isActive: !e.value) : c)
              .toList(),
        ),
      ),
      (_) {},
    );
  }

  // ── Toggle Premium ────────────────────────────────────────
  Future<void> _onTogglePremium(CategoryPremiumToggled e, Emitter emit) async {
    if (state is! CategoryLoaded) return;
    final current = (state as CategoryLoaded).categories;

    // Optimistic update
    emit(
      CategoryLoaded(
        current
            .map((c) => c.id == e.id ? c.copyWith(isPremium: e.value) : c)
            .toList(),
      ),
    );

    // Firestore — revert on fail
    final result = await _repository.togglePremium(e.id, e.value);
    result.fold(
      (f) => emit(
        CategoryLoaded(
          current
              .map((c) => c.id == e.id ? c.copyWith(isPremium: !e.value) : c)
              .toList(),
        ),
      ),
      (_) {},
    );
  }

  // ── Delete ────────────────────────────────────────────────
  Future<void> _onDelete(CategoryDeleteRequested e, Emitter emit) async {
    if (state is! CategoryLoaded) return;
    final current = (state as CategoryLoaded).categories;

    // Optimistic update
    emit(CategoryLoaded(current.where((c) => c.id != e.id).toList()));

    final result = await _repository.deleteCategory(e.id);
    result.fold(
      (f) => emit(CategoryLoaded(current)), // revert
      (_) {},
    );
  }

  // ── Sort Order ────────────────────────────────────────────
  Future<void> _onSortOrder(CategorySortOrderUpdated e, Emitter emit) async {
    await _repository.updateSortOrder(e.orderedIds);
  }

  // ── Add ───────────────────────────────────────────────────
  Future<void> _onAdd(CategoryAddRequested e, Emitter emit) async {
    emit(const CategoryAdding());

    try {
      String coverUrl = '';

      if (e.coverImageBytes != null && e.coverImageFileName != null) {
        final cloudinary = sl<CloudinaryService>();
        final result = await cloudinary.uploadWallpaper(
          fileBytes: e.coverImageBytes!,
          fileName: e.coverImageFileName!,
          onProgress: null,
        );
        coverUrl = result.secureUrl;
      }

      final data = {
        'name': e.name,
        'slug': e.slug,
        'iconName': e.iconName,
        'accentColor': '#F5C518',
        'wallpaperCount': 0,
        'isPremium': e.isPremium,
        'isActive': e.isActive,
        'coverUrl': coverUrl,
        'sortOrder': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final result = await _repository.addCategory(data);
      result.fold(
        (f) => emit(CategoryError(f.message)),
        (_) => emit(const CategoryAdded()),
      );
    } catch (err) {
      emit(CategoryError(err.toString()));
    }
  }
}
