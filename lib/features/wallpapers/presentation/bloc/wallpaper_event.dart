import 'dart:typed_data';
import 'package:equatable/equatable.dart';

sealed class WallpaperEvent extends Equatable {
  const WallpaperEvent();

  @override
  List<Object?> get props => [];
}

class WallpaperUploadRequested extends WallpaperEvent {
  final String title;
  final String category;
  final List<String> tags;
  final String resolution;
  final int width;
  final int height;
  final bool isPremium;
  final bool isEditorChoice;
  final bool isActive;
  final Uint8List imageBytes;
  final String fileName;

  const WallpaperUploadRequested({
    required this.title,
    required this.category,
    required this.tags,
    required this.resolution,
    required this.width,
    required this.height,
    required this.isPremium,
    required this.isEditorChoice,
    required this.isActive,
    required this.imageBytes,
    required this.fileName,
  });

  @override
  List<Object?> get props => [
        title,
        category,
        tags,
        resolution,
        width,
        height,
        isPremium,
        isEditorChoice,
        isActive,
        imageBytes,
        fileName,
      ];
}

class WallpaperDeleteRequested extends WallpaperEvent {
  final String wallpaperId;
  final String title;
  final String category;
  final String publicId;

  const WallpaperDeleteRequested({
    required this.wallpaperId,
    required this.title,
    required this.category,
    required this.publicId,
  });

  @override
  List<Object?> get props => [wallpaperId, title, category, publicId];
}
