// lib/features/auth/domain/entities/admin_user_entity.dart

import 'package:equatable/equatable.dart';

class AdminUserEntity extends Equatable {
  final String uid;
  final String email;

  const AdminUserEntity({required this.uid, required this.email});

  @override
  List<Object> get props => [uid, email];
}
