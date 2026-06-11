// lib/features/categories/data/datasources/category_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

abstract interface class CategoryDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> toggleActive(String id, bool value);
  Future<void> togglePremium(String id, bool value);
  Future<void> deleteCategory(String id);
  Future<void> updateSortOrder(List<String> orderedIds);
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final FirebaseFirestore _firestore;
  const CategoryDataSourceImpl(this._firestore);

  CollectionReference get _col => _firestore.collection('categories');

  @override
  Future<List<CategoryModel>> getCategories() async {
    final snap = await _col.orderBy('sortOrder').get();
    return snap.docs
        .map(
          (d) => CategoryModel.fromMap(d.id, d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> toggleActive(String id, bool value) =>
      _col.doc(id).update({'isActive': value});

  @override
  Future<void> togglePremium(String id, bool value) =>
      _col.doc(id).update({'isPremium': value});

  @override
  Future<void> deleteCategory(String id) => _col.doc(id).delete();

  @override
  Future<void> updateSortOrder(List<String> orderedIds) async {
    final batch = _firestore.batch();
    for (int i = 0; i < orderedIds.length; i++) {
      batch.update(_col.doc(orderedIds[i]), {'sortOrder': i});
    }
    await batch.commit();
  }
}
