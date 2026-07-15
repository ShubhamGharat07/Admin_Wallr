import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/cloudinary_service.dart';

abstract interface class WallpaperDataSource {
  Future<void> addWallpaper(Map<String, dynamic> data);
  Future<void> removeWallpaper(String wallpaperId, String category, String publicId);
}

class WallpaperDataSourceImpl implements WallpaperDataSource {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinary;
  const WallpaperDataSourceImpl(this._firestore, this._cloudinary);

  @override
  Future<void> addWallpaper(Map<String, dynamic> data) async {
    final batch = _firestore.batch();

    final wallpaperRef = _firestore.collection('wallpapers').doc();
    batch.set(wallpaperRef, data);

    final categorySlug = data['category'] as String?;
    if (categorySlug != null && categorySlug.isNotEmpty) {
      final categoryQuery = await _firestore
          .collection('categories')
          .where('slug', isEqualTo: categorySlug)
          .limit(1)
          .get();

      if (categoryQuery.docs.isNotEmpty) {
        final categoryDocRef = categoryQuery.docs.first.reference;
        batch.update(categoryDocRef, {
          'wallpaperCount': FieldValue.increment(1),
        });
      }
    }

    await batch.commit();
  }

  @override
  Future<void> removeWallpaper(String wallpaperId, String category, String publicId) async {
    // Delete from Cloudinary
    if (publicId.isNotEmpty) {
      await _cloudinary.deleteWallpaper(publicId);
    }

    // Delete from Firestore and update category count
    final batch = _firestore.batch();

    final wallpaperRef = _firestore.collection('wallpapers').doc(wallpaperId);
    batch.delete(wallpaperRef);

    if (category.isNotEmpty) {
      final categoryQuery = await _firestore
          .collection('categories')
          .where('slug', isEqualTo: category)
          .limit(1)
          .get();

      if (categoryQuery.docs.isNotEmpty) {
        final categoryDocRef = categoryQuery.docs.first.reference;
        batch.update(categoryDocRef, {
          'wallpaperCount': FieldValue.increment(-1),
        });
      }
    }

    await batch.commit();
  }
}
