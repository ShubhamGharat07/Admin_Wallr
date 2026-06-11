// lib/core/widgets/admin_card.dart

import 'package:flutter/material.dart';
import '../constants/admin_colors.dart';
import '../constants/admin_dimensions.dart';

class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  const AdminCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
          hoverColor: AdminColors.rowHover.withValues(alpha: 0.5),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AdminDimensions.md),
            child: child,
          ),
        ),
      ),
    );
  }
}
