// lib/features/auth/data/models/admin_user_model.dart

import '../../domain/entities/admin_user_entity.dart';

class AdminUserModel extends AdminUserEntity {
  const AdminUserModel({required super.uid, required super.email});
}
