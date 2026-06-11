// lib/core/widgets/admin_badge.dart

import 'package:flutter/material.dart';
import '../constants/admin_colors.dart';
import '../constants/admin_dimensions.dart';

enum BadgeType {
  success,
  error,
  warning,
  info,
  premium,
  free,
  active,
  inactive,
}

class AdminBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const AdminBadge({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    final (color, bg) = _colors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AdminDimensions.badgeRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  (Color, Color) _colors() => switch (type) {
    BadgeType.success => (AdminColors.success, AdminColors.successBg),
    BadgeType.error => (AdminColors.error, AdminColors.errorBg),
    BadgeType.warning => (AdminColors.warning, AdminColors.warningBg),
    BadgeType.info => (AdminColors.info, AdminColors.infoBg),
    BadgeType.premium => (AdminColors.premium, AdminColors.premiumBg),
    BadgeType.free => (AdminColors.free, AdminColors.freeBg),
    BadgeType.active => (AdminColors.success, AdminColors.successBg),
    BadgeType.inactive => (AdminColors.free, AdminColors.freeBg),
  };
}
