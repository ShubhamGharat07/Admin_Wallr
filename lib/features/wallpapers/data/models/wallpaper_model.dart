import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/wallpaper_entity.dart';

class WallpaperModel extends WallpaperEntity {
  const WallpaperModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.thumbnailUrl,
    required super.category,
    required super.tags,
    required super.resolution,
    required super.width,
    required super.height,
    required super.isPremium,
    required super.isActive,
    required super.isEditorChoice,
    required super.isTrendingPinned,
    required super.downloadCount,
    required super.viewCount,
    required super.uploadedBy,
    required super.createdAt,
  });

  factory WallpaperModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      return DateTime.now();
    }

    return WallpaperModel(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      resolution: map['resolution'] ?? '',
      width: map['width'] ?? 0,
      height: map['height'] ?? 0,
      isPremium: map['isPremium'] ?? false,
      isActive: map['isActive'] ?? true,
      isEditorChoice: map['isEditorChoice'] ?? false,
      isTrendingPinned: map['isTrendingPinned'] ?? false,
      downloadCount: map['downloadCount'] ?? 0,
      viewCount: map['viewCount'] ?? 0,
      uploadedBy: map['uploadedBy'] ?? '',
      createdAt: parseDateTime(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'imageUrl': imageUrl,
        'thumbnailUrl': thumbnailUrl,
        'category': category,
        'tags': tags,
        'resolution': resolution,
        'width': width,
        'height': height,
        'isPremium': isPremium,
        'isActive': isActive,
        'isEditorChoice': isEditorChoice,
        'isTrendingPinned': isTrendingPinned,
        'downloadCount': downloadCount,
        'viewCount': viewCount,
        'uploadedBy': uploadedBy,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
