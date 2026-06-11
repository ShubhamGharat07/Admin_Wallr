// lib/config/di/injection.dart — updated

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:wallr_admin/features/auth/domain/repositories/admin_auth_repository.dart';
import 'package:wallr_admin/features/categories/data/datasources/category_datasource.dart';
import 'package:wallr_admin/features/categories/data/repositories/category_repository_impl.dart';
import 'package:wallr_admin/features/categories/domain/repositories/category_repository.dart';
import 'package:wallr_admin/features/categories/presentation/bloc/category_bloc.dart';

import '../../core/network/network_info.dart';
import '../../core/utils/cloudinary_service.dart';
import '../../features/auth/data/datasources/admin_auth_datasource.dart';
import '../../features/auth/data/repositories/admin_auth_repository_impl.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ──────────────────────────────────────────────
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );

  // ── Core ──────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );
  sl.registerLazySingleton<CloudinaryService>(
    () => CloudinaryService(sl<Dio>()),
  );

  // ── Auth ──────────────────────────────────────────────────
  sl.registerLazySingleton<AdminAuthDataSource>(
    () => AdminAuthDataSourceImpl(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<AdminAuthRepository>(
    () => AdminAuthRepositoryImpl(
      dataSource: sl<AdminAuthDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton(() => SignInUseCase(sl<AdminAuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AdminAuthRepository>()));
  sl.registerFactory(
    () => AuthBloc(signIn: sl<SignInUseCase>(), signOut: sl<SignOutUseCase>()),
  );

  // Categories
  sl.registerLazySingleton<CategoryDataSource>(
    () => CategoryDataSourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryDataSource>()),
  );
  sl.registerFactory(() => CategoryBloc(sl<CategoryRepository>()));
}
