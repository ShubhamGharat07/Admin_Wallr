// // lib/main.dart

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:responsive_framework/responsive_framework.dart';

// import 'config/di/injection.dart';
// import 'config/routes/app_router.dart';
// import 'core/theme/admin_theme.dart';
// import 'firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await dotenv.load(fileName: '.env', mergeWith: {});

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   await initDependencies();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'WALLR Admin',
//       debugShowCheckedModeBanner: false,
//       theme: AdminTheme.dark,
//       routerConfig: AppRouter.router,
//       builder: (context, child) => ResponsiveBreakpoints.builder(
//         child: child!,
//         breakpoints: const [
//           Breakpoint(start: 0, end: 767, name: MOBILE),
//           Breakpoint(start: 768, end: 1199, name: TABLET),
//           Breakpoint(start: 1200, end: 1920, name: DESKTOP),
//         ],
//       ),
//     );
//   }
// }

// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'config/di/injection.dart';
import 'config/routes/app_router.dart';
import 'core/theme/admin_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'WALLR Admin',
        debugShowCheckedModeBanner: false,
        theme: AdminTheme.dark,
        routerConfig: AppRouter.router,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 767, name: MOBILE),
            const Breakpoint(start: 768, end: 1199, name: TABLET),
            const Breakpoint(start: 1200, end: 1920, name: DESKTOP),
          ],
        ),
      ),
    );
  }
}
