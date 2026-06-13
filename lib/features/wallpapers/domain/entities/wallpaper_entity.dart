import 'package:equatable/equatable.dart';

class WallpaperEntity extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String thumbnailUrl;
  final String category;
  final List<String> tags;
  final String resolution;
  final int width;
  final int height;
  final bool isPremium;
  final bool isActive;
  final bool isEditorChoice;
  final bool isTrendingPinned;
  final int downloadCount;
  final int viewCount;
  final String uploadedBy;
  final DateTime createdAt;

  const WallpaperEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.category,
    required this.tags,
    required this.resolution,
    required this.width,
    required this.height,
    required this.isPremium,
    required this.isActive,
    required this.isEditorChoice,
    required this.isTrendingPinned,
    required this.downloadCount,
    required this.viewCount,
    required this.uploadedBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        thumbnailUrl,
        category,
        tags,
        resolution,
        width,
        height,
        isPremium,
        isActive,
        isEditorChoice,
        isTrendingPinned,
        downloadCount,
        viewCount,
        uploadedBy,
        createdAt,
      ];
}
