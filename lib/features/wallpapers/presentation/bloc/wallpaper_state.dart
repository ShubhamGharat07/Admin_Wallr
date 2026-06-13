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
