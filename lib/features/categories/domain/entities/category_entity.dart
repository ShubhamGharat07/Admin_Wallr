// // lib/features/categories/domain/entities/category_entity.dart

// import 'package:equatable/equatable.dart';

// class CategoryEntity extends Equatable {
//   final String id;
//   final String name;
//   final String slug;
//   final String iconName;
//   final String accentColor;
//   final int wallpaperCount;
//   final bool isPremium;
//   final bool isActive;
//   final int sortOrder;

//   const CategoryEntity({
//     required this.id,
//     required this.name,
//     required this.slug,
//     required this.iconName,
//     required this.accentColor,
//     required this.wallpaperCount,
//     required this.isPremium,
//     required this.isActive,
//     required this.sortOrder,
//   });

//   @override
//   List<Object> get props => [id];
// }

// lib/features/categories/domain/entities/category_entity.dart

import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String iconName;
  final String accentColor;
  final int wallpaperCount;
  final bool isPremium;
  final bool isActive;
  final int sortOrder;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.iconName,
    required this.accentColor,
    required this.wallpaperCount,
    required this.isPremium,
    required this.isActive,
    required this.sortOrder,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? slug,
    String? iconName,
    String? accentColor,
    int? wallpaperCount,
    bool? isPremium,
    bool? isActive,
    int? sortOrder,
  }) => CategoryEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    iconName: iconName ?? this.iconName,
    accentColor: accentColor ?? this.accentColor,
    wallpaperCount: wallpaperCount ?? this.wallpaperCount,
    isPremium: isPremium ?? this.isPremium,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  @override
  List<Object> get props => [
    id,
    name,
    slug,
    iconName,
    accentColor,
    wallpaperCount,
    isPremium,
    isActive,
    sortOrder,
  ];
}
