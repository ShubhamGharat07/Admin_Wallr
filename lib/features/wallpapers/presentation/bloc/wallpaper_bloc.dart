// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../config/di/injection.dart';
// import '../../../../core/utils/cloudinary_service.dart';
// import '../../../../core/utils/logger.dart';
// import '../../domain/repositories/wallpaper_repository.dart';
// import 'wallpaper_event.dart';
// import 'wallpaper_state.dart';

// class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
//   final WallpaperRepository _repository;

//   WallpaperBloc(this._repository) : super(const WallpaperInitial()) {
//     on<WallpaperUploadRequested>(_onUpload);
//   }

//   Future<void> _onUpload(WallpaperUploadRequested e, Emitter<WallpaperState> emit) async {
//     emit(const WallpaperUploading());

//     try {
//       final cloudinary = sl<CloudinaryService>();

//       // 1. Upload the wallpaper image to Cloudinary
//       final uploadResult = await cloudinary.uploadWallpaper(
//         fileBytes: e.imageBytes,
//         fileName: e.fileName,
//         onProgress: null,
//       );

//       final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';

//       // 2. Prepare Firestore document data
//       final data = {
//         'title': e.title,
//         'imageUrl': uploadResult.secureUrl,
//         'thumbnailUrl': cloudinary.thumbnailUrl(uploadResult.secureUrl),
//         'category': e.category,
//         'tags': e.tags,
//         'resolution': e.resolution,
//         'width': e.width,
//         'height': e.height,
//         'isPremium': e.isPremium,
//         'isActive': e.isActive,
//         'isEditorChoice': e.isEditorChoice,
//         'isTrendingPinned': false,
//         'downloadCount': 0,
//         'viewCount': 0,
//         'uploadedBy': currentUserId,
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       // 3. Save to Firestore
//       final result = await _repository.uploadWallpaper(data);
//       result.fold(
//         (failure) {
//           AppLogger.error(
//             'Failed to save wallpaper metadata to Firestore: ${failure.message}',
//             tag: 'WallpaperBloc',
//           );
//           emit(WallpaperUploadError(failure.message));
//         },
//         (_) => emit(const WallpaperUploadSuccess()),
//       );
//     } catch (err, stackTrace) {
//       AppLogger.error(
//         'Exception during wallpaper upload process',
//         error: err,
//         stackTrace: stackTrace,
//         tag: 'WallpaperBloc',
//       );
//       emit(WallpaperUploadError(err.toString()));
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di/injection.dart';
import '../../../../core/utils/cloudinary_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/wallpaper_repository.dart';
import 'wallpaper_event.dart';
import 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final WallpaperRepository _repository;

  WallpaperBloc(this._repository) : super(const WallpaperInitial()) {
    on<WallpaperUploadRequested>(_onUpload);
    on<WallpaperDeleteRequested>(_onDelete);
  }

  Future<void> _onUpload(
    WallpaperUploadRequested e,
    Emitter<WallpaperState> emit,
  ) async {
    emit(const WallpaperUploading());

    try {
      final cloudinary = sl<CloudinaryService>();

      final uploadResult = await cloudinary.uploadWallpaper(
        fileBytes: e.imageBytes,
        fileName: e.fileName,
        onProgress: null,
      );

      final currentUserId =
          FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';

      final data = {
        'title': e.title,
        'imageUrl': uploadResult.secureUrl,
        'thumbnailUrl': cloudinary.previewUrl(uploadResult.secureUrl),
        'publicId': uploadResult.publicId,
        'category': e.category,
        'tags': e.tags,
        'resolution': e.resolution,
        'width': e.width,
        'height': e.height,
        'isPremium': e.isPremium,
        'isActive': e.isActive,
        'isEditorChoice': e.isEditorChoice,
        'isTrendingPinned': false,
        'downloadCount': 0,
        'viewCount': 0,
        'uploadedBy': currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final result = await _repository.uploadWallpaper(data);
      result.fold((failure) {
        AppLogger.error(
          'Failed to save wallpaper metadata to Firestore: ${failure.message}',
          tag: 'WallpaperBloc',
        );
        emit(WallpaperUploadError(failure.message));
      }, (_) => emit(const WallpaperUploadSuccess()));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Exception during wallpaper upload process',
        error: err,
        stackTrace: stackTrace,
        tag: 'WallpaperBloc',
      );
      emit(WallpaperUploadError(err.toString()));
    }
  }

  Future<void> _onDelete(
    WallpaperDeleteRequested e,
    Emitter<WallpaperState> emit,
  ) async {
    AppLogger.info('DELETE REQUEST RECEIVED', tag: 'WallpaperBloc');
    AppLogger.info('Wallpaper ID: ${e.wallpaperId}', tag: 'WallpaperBloc');
    AppLogger.info('Title: ${e.title}', tag: 'WallpaperBloc');
    AppLogger.info('Category: ${e.category}', tag: 'WallpaperBloc');
    AppLogger.info('Public ID: ${e.publicId}', tag: 'WallpaperBloc');

    emit(WallpaperDeleting(e.wallpaperId));
    AppLogger.info('EMITTED: WallpaperDeleting state', tag: 'WallpaperBloc');

    try {
      AppLogger.info('Calling repository.deleteWallpaper()', tag: 'WallpaperBloc');
      final result = await _repository.deleteWallpaper(e.wallpaperId, e.category, e.publicId);
      AppLogger.info('Repository returned result', tag: 'WallpaperBloc');

      result.fold(
        (failure) {
          AppLogger.error(
            'Repository returned failure: ${failure.message}',
            tag: 'WallpaperBloc',
          );
          emit(WallpaperDeleteError(failure.message, e.wallpaperId));
          AppLogger.info('EMITTED: WallpaperDeleteError state', tag: 'WallpaperBloc');
        },
        (_) {
          AppLogger.info('Repository returned success', tag: 'WallpaperBloc');
          emit(WallpaperDeleteSuccess(e.wallpaperId, e.title));
          AppLogger.info('EMITTED: WallpaperDeleteSuccess state', tag: 'WallpaperBloc');
        },
      );
    } catch (err, stackTrace) {
      AppLogger.error(
        'Exception during wallpaper delete process: $err',
        error: err,
        stackTrace: stackTrace,
        tag: 'WallpaperBloc',
      );
      emit(WallpaperDeleteError(err.toString(), e.wallpaperId));
      AppLogger.info('EMITTED: WallpaperDeleteError state (from exception)', tag: 'WallpaperBloc');
    }
  }
}
