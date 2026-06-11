// // lib/config/routes/app_router.dart

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:go_router/go_router.dart';

// import '../../core/constants/admin_colors.dart';
// import '../../core/constants/admin_text_styles.dart';
// import '../../core/widgets/admin_shell.dart';
// import '../../features/auth/presentation/bloc/auth_bloc.dart';
// import '../../features/auth/presentation/pages/login_page.dart';
// import 'route_names.dart';

// // Listens to Firebase auth state → GoRouter auto re-evaluates redirect
// class _AuthChangeNotifier extends ChangeNotifier {
//   _AuthChangeNotifier() {
//     FirebaseAuth.instance.authStateChanges().listen((_) => notifyListeners());
//   }
// }

// abstract final class AppRouter {
//   static final _authNotifier = _AuthChangeNotifier();

//   static final router = GoRouter(
//     initialLocation: RouteNames.login,
//     refreshListenable: _authNotifier,
//     redirect: _authGuard,
//     debugLogDiagnostics: false,
//     routes: [
//       // ── Login ──────────────────────────────────────────────────
//       GoRoute(
//         path: RouteNames.login,
//         name: 'login',
//         builder: (context, state) => BlocProvider(
//           create: (_) => GetIt.I<AuthBloc>(),
//           child: const LoginPage(),
//         ),
//       ),

//       // ── Authenticated Shell ─────────────────────────────────────
//       // StatefulShellRoute — preserves each page's state on sidebar nav
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) =>
//             AdminShell(navigationShell: navigationShell),
//         branches: [
//           // 0 — Dashboard
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.dashboard,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Dashboard',
//                   icon: Icons.dashboard_outlined,
//                 ),
//               ),
//             ],
//           ),

//           // 1 — Wallpapers + nested upload route
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.wallpapers,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Wallpapers',
//                   icon: Icons.image_outlined,
//                 ),
//                 routes: [
//                   GoRoute(
//                     path: 'upload', // relative → resolves to /wallpapers/upload
//                     builder: (_, __) => const _PlaceholderPage(
//                       title: 'Upload Wallpaper',
//                       icon: Icons.upload_file_outlined,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           // 2 — Categories
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.categories,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Categories',
//                   icon: Icons.category_outlined,
//                 ),
//               ),
//             ],
//           ),

//           // 3 — Collections
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.collections,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Collections',
//                   icon: Icons.collections_outlined,
//                 ),
//               ),
//             ],
//           ),

//           // 4 — Featured
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.featured,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Featured Content',
//                   icon: Icons.star_outline_rounded,
//                 ),
//               ),
//             ],
//           ),

//           // 5 — Users
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.users,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Users',
//                   icon: Icons.people_outline_rounded,
//                 ),
//               ),
//             ],
//           ),

//           // 6 — Analytics
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.analytics,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Analytics',
//                   icon: Icons.analytics_outlined,
//                 ),
//               ),
//             ],
//           ),

//           // 7 — Subscriptions
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.subscriptions,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Subscriptions',
//                   icon: Icons.workspace_premium_outlined,
//                 ),
//               ),
//             ],
//           ),

//           // 8 — Notifications
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.notifications,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Push Notifications',
//                   icon: Icons.notifications_outlined,
//                 ),
//               ),
//             ],
//           ),

//           // 9 — Announcements
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.announcements,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'Announcements',
//                   icon: Icons.campaign_outlined,
//                 ),
//               ),
//             ],
//           ),

//           // 10 — Settings
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: RouteNames.settings,
//                 builder: (_, __) => const _PlaceholderPage(
//                   title: 'App Settings',
//                   icon: Icons.settings_outlined,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   );

//   // ── Auth Guard ─────────────────────────────────────────────────
//   static String? _authGuard(BuildContext context, GoRouterState state) {
//     final isLoggedIn = FirebaseAuth.instance.currentUser != null;
//     final isOnLogin = state.matchedLocation == RouteNames.login;

//     if (!isLoggedIn && !isOnLogin) return RouteNames.login; // force login
//     if (isLoggedIn && isOnLogin) return RouteNames.dashboard; // skip login
//     return null;
//   }
// }

// // ─── Placeholder — replace with real page when feature is built ───────────────

// class _PlaceholderPage extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   const _PlaceholderPage({required this.title, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AdminColors.background,
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 64, color: AdminColors.border),
//             const SizedBox(height: 16),
//             Text(title, style: AdminTextStyles.headlineMd(context)),
//             const SizedBox(height: 8),
//             Text(
//               'Coming soon — implementation in progress',
//               style: AdminTextStyles.bodyMdMuted(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/config/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/admin_shell.dart';
import '../../features/announcements/presentation/pages/announcements_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/collections/presentation/pages/collections_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/featured/presentation/pages/featured_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/subscriptions/presentation/pages/subscriptions_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
import '../../features/wallpapers/presentation/pages/upload_page.dart';
import '../../features/wallpapers/presentation/pages/wallpapers_page.dart';
import 'route_names.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.login,
    redirect: _guard,
    routes: [
      // ── Login ──────────────────────────────────────────────
      GoRoute(path: RouteNames.login, builder: (_, __) => const LoginPage()),

      // ── Shell ──────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => AdminShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.dashboard,
                builder: (_, __) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.wallpapers,
                builder: (_, __) => const WallpapersPage(),
              ),
              GoRoute(
                path: RouteNames.uploadWallpaper,
                builder: (_, __) => const UploadPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.categories,
                builder: (_, __) => const CategoriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.collections,
                builder: (_, __) => const CollectionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.featured,
                builder: (_, __) => const FeaturedPage(),
              ),
            ],
          ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: RouteNames.users,
          //       builder: (_, __) => const UsersPage(),
          //     ),
          //   ],
          // ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.notifications,
                builder: (_, __) => const NotificationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.announcements,
                builder: (_, __) => const AnnouncementsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.subscriptions,
                builder: (_, __) => const SubscriptionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.analytics,
                builder: (_, __) => const AnalyticsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.settings,
                builder: (_, __) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static String? _guard(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final isLoggedIn = authState is AuthSuccess;
    final isOnLogin = state.uri.path == RouteNames.login;

    if (!isLoggedIn && !isOnLogin) return RouteNames.login;
    if (isLoggedIn && isOnLogin) return RouteNames.dashboard;
    return null;
  }
}
