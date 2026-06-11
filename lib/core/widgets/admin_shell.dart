// // lib/core/widgets/admin_shell.dart

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../utils/responsive_helper.dart';
// import '../constants/admin_colors.dart';
// import 'admin_sidebar.dart';
// import 'admin_topbar.dart';

// class AdminShell extends StatefulWidget {
//   final StatefulNavigationShell navigationShell;

//   const AdminShell({super.key, required this.navigationShell});

//   @override
//   State<AdminShell> createState() => _AdminShellState();
// }

// class _AdminShellState extends State<AdminShell> {
//   final _drawerKey = GlobalKey<ScaffoldState>();

//   // Current page title from route
//   String _getTitle(BuildContext context) {
//     final path = GoRouterState.of(context).uri.path;
//     return switch (path) {
//       '/dashboard' => 'Dashboard',
//       '/wallpapers' => 'Wallpapers',
//       '/wallpapers/upload' => 'Upload Wallpaper',
//       '/categories' => 'Categories',
//       '/collections' => 'Collections',
//       '/featured' => 'Featured Content',
//       '/users' => 'Users',
//       '/notifications' => 'Notifications',
//       '/announcements' => 'Announcements',
//       '/subscriptions' => 'Subscriptions',
//       '/analytics' => 'Analytics',
//       '/settings' => 'Settings',
//       _ => 'WALLR Admin',
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = ResponsiveHelper.isMobile(context);
//     final isTablet = ResponsiveHelper.isTablet(context);

//     return Scaffold(
//       key: _drawerKey,
//       backgroundColor: AdminColors.background,

//       // Mobile drawer
//       drawer: isMobile
//           ? Drawer(
//               backgroundColor: AdminColors.sidebar,
//               child: const AdminSidebar(isCollapsed: false),
//             )
//           : null,

//       body: Row(
//         children: [
//           // ── Sidebar (desktop + tablet) ─────────────────────
//           if (!isMobile) AdminSidebar(isCollapsed: isTablet),

//           // ── Main content ───────────────────────────────────
//           Expanded(
//             child: Column(
//               children: [
//                 // TopBar
//                 AdminTopBar(
//                   title: _getTitle(context),
//                   onMenuTap: isMobile
//                       ? () => _drawerKey.currentState?.openDrawer()
//                       : null,
//                 ),

//                 // Page content
//                 Expanded(child: widget.navigationShell),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/core/widgets/admin_shell.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/admin_colors.dart';
import '../utils/responsive_helper.dart';
import 'admin_sidebar.dart';
import 'admin_topbar.dart';

class AdminShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AdminShell({super.key, required this.navigationShell});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _pageTitle(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return switch (path) {
      '/dashboard' => 'Dashboard',
      '/wallpapers' => 'Wallpapers',
      '/wallpapers/upload' => 'Upload Wallpaper',
      '/categories' => 'Categories',
      '/collections' => 'Collections',
      '/featured' => 'Featured Content',
      '/users' => 'Users',
      '/notifications' => 'Notifications',
      '/announcements' => 'Announcements',
      '/subscriptions' => 'Subscriptions',
      '/analytics' => 'Analytics',
      '/settings' => 'Settings',
      _ => 'WALLR Admin',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AdminColors.background,
      drawer: isMobile
          ? Drawer(
              backgroundColor: AdminColors.sidebar,
              child: const AdminSidebar(isCollapsed: false),
            )
          : null,
      body: Row(
        children: [
          // Sidebar — desktop full, tablet collapsed, mobile hidden
          if (!isMobile) AdminSidebar(isCollapsed: isTablet),

          // Content area
          Expanded(
            child: Column(
              children: [
                AdminTopBar(
                  title: _pageTitle(context),
                  onMenuTap: isMobile
                      ? () => _scaffoldKey.currentState?.openDrawer()
                      : null,
                ),
                Expanded(child: widget.navigationShell),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
