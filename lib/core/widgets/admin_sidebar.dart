// lib/core/widgets/admin_sidebar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/admin_colors.dart';
import '../constants/admin_dimensions.dart';
import '../constants/admin_strings.dart';
import '../constants/admin_text_styles.dart';

// ─── Nav Item Data Model ──────────────────────────────────────────────────────

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

const _kNavItems = [
  _NavItem(
    label: AdminStrings.navDashboard,
    icon: Icons.dashboard_outlined,
    route: '/dashboard',
  ),
  _NavItem(
    label: AdminStrings.navWallpapers,
    icon: Icons.image_outlined,
    route: '/wallpapers',
  ),
  _NavItem(
    label: AdminStrings.navCategories,
    icon: Icons.category_outlined,
    route: '/categories',
  ),
  _NavItem(
    label: AdminStrings.navCollections,
    icon: Icons.collections_outlined,
    route: '/collections',
  ),
  _NavItem(
    label: AdminStrings.navFeatured,
    icon: Icons.star_outline,
    route: '/featured',
  ),
  _NavItem(
    label: AdminStrings.navUsers,
    icon: Icons.group_outlined,
    route: '/users',
  ),
  _NavItem(
    label: AdminStrings.navNotifications,
    icon: Icons.notifications_outlined,
    route: '/notifications',
  ),
  _NavItem(
    label: AdminStrings.navAnnouncements,
    icon: Icons.campaign_outlined,
    route: '/announcements',
  ),
  _NavItem(
    label: AdminStrings.navSubscriptions,
    icon: Icons.payments_outlined,
    route: '/subscriptions',
  ),
  _NavItem(
    label: AdminStrings.navAnalytics,
    icon: Icons.bar_chart_outlined,
    route: '/analytics',
  ),
  _NavItem(
    label: AdminStrings.navSettings,
    icon: Icons.settings_outlined,
    route: '/settings',
  ),
];

// ─── Main Sidebar ─────────────────────────────────────────────────────────────

class AdminSidebar extends StatelessWidget {
  final bool isCollapsed;
  const AdminSidebar({super.key, this.isCollapsed = false});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      width: isCollapsed ? 64.0 : 260.0,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AdminColors.sidebar,
        border: Border(right: BorderSide(color: AdminColors.border)),
      ),
      child: Column(
        children: [
          // Logo
          _Logo(isCollapsed: isCollapsed),
          Divider(height: 1, color: AdminColors.border),
          SizedBox(height: AdminDimensions.sm),

          // Upload CTA
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 12.0 : AdminDimensions.md,
              vertical: AdminDimensions.sm,
            ),
            child: isCollapsed ? _UploadIconBtn() : _UploadBtn(),
          ),

          SizedBox(height: AdminDimensions.xs),

          // Nav items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 8.0 : AdminDimensions.sm,
                vertical: AdminDimensions.xs,
              ),
              children: _kNavItems.map((item) {
                final isActive = currentRoute.startsWith(item.route);
                return _NavTile(
                  item: item,
                  isActive: isActive,
                  isCollapsed: isCollapsed,
                  onTap: () => context.go(item.route),
                );
              }).toList(),
            ),
          ),

          Divider(height: 1, color: AdminColors.border),

          // Bottom: Help + Sign out
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 8.0 : AdminDimensions.sm,
              vertical: AdminDimensions.sm,
            ),
            child: Column(
              children: [
                _NavTile(
                  item: const _NavItem(
                    label: AdminStrings.navHelp,
                    icon: Icons.help_outline,
                    route: '',
                  ),
                  isActive: false,
                  isCollapsed: isCollapsed,
                  onTap: () {},
                ),
                _NavTile(
                  item: const _NavItem(
                    label: AdminStrings.signOut,
                    icon: Icons.logout,
                    route: '',
                  ),
                  isActive: false,
                  isCollapsed: isCollapsed,
                  onTap: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Logo ─────────────────────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  final bool isCollapsed;
  const _Logo({required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AdminDimensions.topBarHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 12.0 : AdminDimensions.md,
        ),
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            CustomPaint(size: const Size(20, 24), painter: _DiamondPainter()),
            if (!isCollapsed) ...[
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AdminStrings.appName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AdminColors.gold,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    AdminStrings.adminRole,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AdminColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Upload Buttons ───────────────────────────────────────────────────────────

class _UploadBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AdminDimensions.buttonHeightMd,
      child: ElevatedButton.icon(
        onPressed: () => context.go('/wallpapers/upload'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminColors.gold,
          foregroundColor: AdminColors.onGold,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminDimensions.buttonRadius),
          ),
        ),
        icon: const Icon(Icons.upload, size: 16),
        label: const Text(
          AdminStrings.uploadWallpaper,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _UploadIconBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: ElevatedButton(
        onPressed: () => context.go('/wallpapers/upload'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminColors.gold,
          foregroundColor: AdminColors.onGold,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminDimensions.buttonRadius),
          ),
        ),
        child: const Icon(Icons.upload, size: 18),
      ),
    );
  }
}

// ─── Nav Tile ─────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isCollapsed ? item.label : '',
      preferBelow: false,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: AdminDimensions.sidebarItemHeight,
          margin: const EdgeInsets.only(bottom: 2),
          padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 12),
          decoration: BoxDecoration(
            color: isActive ? AdminColors.sidebarActiveBg : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: AdminColors.gold.withOpacity(0.2))
                : null,
          ),
          child: Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: AdminDimensions.sidebarIconSize,
                color: isActive ? AdminColors.gold : AdminColors.textSecondary,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: isActive
                      ? AdminTextStyles.sidebarItemActive
                      : AdminTextStyles.sidebarItem,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Diamond Painter ──────────────────────────────────────────────────────────

class _DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AdminColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height * 0.38)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height * 0.38)
      ..close();

    final inner = Path()
      ..moveTo(size.width * 0.25, size.height * 0.38)
      ..lineTo(size.width / 2, size.height * 0.6)
      ..lineTo(size.width * 0.75, size.height * 0.38);

    canvas.drawPath(path, paint);
    canvas.drawPath(inner, paint..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
