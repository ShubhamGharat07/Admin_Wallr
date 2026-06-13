import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class WallpaperDataSource {
  Future<void> addWallpaper(Map<String, dynamic> data);
}

class WallpaperDataSourceImpl implements WallpaperDataSource {
  final FirebaseFirestore _firestore;
  const WallpaperDataSourceImpl(this._firestore);

  @override
  Future<void> addWallpaper(Map<String, dynamic> data) async {
    final batch = _firestore.batch();

    // Generate wallpaper doc reference
    final wallpaperRef = _firestore.collection('wallpapers').doc();
    batch.set(wallpaperRef, data);

    // Update the corresponding category's wallpaper count
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
}
