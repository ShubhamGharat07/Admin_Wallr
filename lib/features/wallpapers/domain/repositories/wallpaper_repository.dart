import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract interface class WallpaperRepository {
  Future<Either<Failure, void>> uploadWallpaper(Map<String, dynamic> data);
}
