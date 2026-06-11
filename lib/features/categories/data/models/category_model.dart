// lib/features/categories/data/models/category_model.dart

import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.iconName,
    required super.accentColor,
    required super.wallpaperCount,
    required super.isPremium,
    required super.isActive,
    required super.sortOrder,
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) =>
      CategoryModel(
        id: id,
        name: map['name'] ?? '',
        slug: map['slug'] ?? '',
        iconName: map['iconName'] ?? 'category',
        accentColor: map['accentColor'] ?? '#F5C518',
        wallpaperCount: map['wallpaperCount'] ?? 0,
        isPremium: map['isPremium'] ?? false,
        isActive: map['isActive'] ?? true,
        sortOrder: map['sortOrder'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
    'name': name,
    'slug': slug,
    'iconName': iconName,
    'accentColor': accentColor,
    'wallpaperCount': wallpaperCount,
    'isPremium': isPremium,
    'isActive': isActive,
    'sortOrder': sortOrder,
  };
}
