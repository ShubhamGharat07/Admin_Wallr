// lib/core/widgets/admin_button.dart

import 'package:flutter/material.dart';
import '../constants/admin_colors.dart';
import '../constants/admin_dimensions.dart';
import '../constants/admin_text_styles.dart';

enum _BtnVariant { primary, secondary, ghost, danger }

class AdminButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final _BtnVariant _variant;
  final double? width;

  const AdminButton.primary({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : _variant = _BtnVariant.primary;

  const AdminButton.secondary({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : _variant = _BtnVariant.secondary;

  const AdminButton.ghost({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : _variant = _BtnVariant.ghost;

  const AdminButton.danger({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : _variant = _BtnVariant.danger;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = _style();
    return SizedBox(
      width: width,
      height: AdminDimensions.buttonHeightMd,
      child: TextButton(
        onPressed: isLoading ? null : onTap,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg?.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminDimensions.buttonRadius),
            side: border != null ? BorderSide(color: border) : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AdminDimensions.iconSm, color: fg),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: AdminTextStyles.labelLg(context).copyWith(color: fg),
                  ),
                ],
              ),
      ),
    );
  }

  (Color?, Color, Color?) _style() => switch (_variant) {
    _BtnVariant.primary => (AdminColors.gold, AdminColors.onGold, null),
    _BtnVariant.secondary => (
      AdminColors.surface,
      AdminColors.textPrimary,
      AdminColors.border,
    ),
    _BtnVariant.ghost => (Colors.transparent, AdminColors.textSecondary, null),
    _BtnVariant.danger => (
      AdminColors.errorBg,
      AdminColors.error,
      AdminColors.error,
    ),
  };
}
