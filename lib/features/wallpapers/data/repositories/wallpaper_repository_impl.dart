import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/wallpaper_repository.dart';
import '../datasources/wallpaper_datasource.dart';

class WallpaperRepositoryImpl implements WallpaperRepository {
  final WallpaperDataSource _dataSource;
  const WallpaperRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> uploadWallpaper(Map<String, dynamic> data) async {
    try {
      await _dataSource.addWallpaper(data);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'uploadWallpaper failed in repository with data: $data',
        error: e,
        stackTrace: stackTrace,
        tag: 'WallpaperRepository',
      );
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteWallpaper(String wallpaperId, String category, String publicId) async {
    try {
      await _dataSource.removeWallpaper(wallpaperId, category, publicId);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'deleteWallpaper failed in repository for ID: $wallpaperId',
        error: e,
        stackTrace: stackTrace,
        tag: 'WallpaperRepository',
      );
      return const Left(ServerFailure());
    }
  }
}
