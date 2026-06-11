// lib/features/auth/data/datasources/admin_auth_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/exceptions.dart';
import '../models/admin_user_model.dart';

abstract interface class AdminAuthDataSource {
  Future<AdminUserModel> signIn(String email, String password);
  Future<void> signOut();
  AdminUserModel? getCurrentUser();
}

class AdminAuthDataSourceImpl implements AdminAuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  const AdminAuthDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  @override
  Future<AdminUserModel> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Check admins collection
      final doc = await _firestore
          .collection('admins')
          .doc(cred.user!.uid)
          .get();

      if (!doc.exists) {
        await _auth.signOut();
        throw const UnauthorizedException();
      }
      return AdminUserModel(uid: cred.user!.uid, email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Login failed.', code: e.code);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  AdminUserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AdminUserModel(uid: user.uid, email: user.email ?? '');
  }
}
