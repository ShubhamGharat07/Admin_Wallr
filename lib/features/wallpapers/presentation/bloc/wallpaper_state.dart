import 'package:equatable/equatable.dart';

sealed class WallpaperState extends Equatable {
  const WallpaperState();

  @override
  List<Object?> get props => [];
}

class WallpaperInitial extends WallpaperState {
  const WallpaperInitial();
}

class WallpaperUploading extends WallpaperState {
  const WallpaperUploading();
}

class WallpaperUploadSuccess extends WallpaperState {
  const WallpaperUploadSuccess();
}

class WallpaperUploadError extends WallpaperState {
  final String message;
  const WallpaperUploadError(this.message);

  @override
  List<Object?> get props => [message];
}

class WallpaperDeleting extends WallpaperState {
  final String wallpaperId;
  const WallpaperDeleting(this.wallpaperId);

  @override
  List<Object?> get props => [wallpaperId];
}

class WallpaperDeleteSuccess extends WallpaperState {
  final String wallpaperId;
  final String title;
  const WallpaperDeleteSuccess(this.wallpaperId, this.title);

  @override
  List<Object?> get props => [wallpaperId, title];
}

class WallpaperDeleteError extends WallpaperState {
  final String message;
  final String wallpaperId;
  const WallpaperDeleteError(this.message, this.wallpaperId);

  @override
  List<Object?> get props => [message, wallpaperId];
}
