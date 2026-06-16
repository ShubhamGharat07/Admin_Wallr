// lib/core/widgets/app_toast.dart

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../constants/admin_colors.dart';
import '../constants/admin_dimensions.dart';
import '../constants/admin_text_styles.dart';

/// App-wide toast notifications — replaces raw [ScaffoldMessenger] snackbars
/// with themed, animated toasts that match the gold/dark admin theme.
///
/// Reusable across the whole app:
/// ```dart
/// AppToast.success(context, 'Wallpaper uploaded successfully!');
/// AppToast.error(context, 'Upload failed: $message');
/// AppToast.warning(context, 'Please select a category.');
/// AppToast.info(context, 'Changes saved as draft.');
/// ```
abstract final class AppToast {
  static void success(BuildContext context, String message, {String? title}) =>
      _show(
        context,
        message: message,
        title: title ?? 'Success',
        type: ToastificationType.success,
        accent: AdminColors.gold,
        icon: Icons.check_circle_outline_rounded,
      );

  static void error(BuildContext context, String message, {String? title}) =>
      _show(
        context,
        message: message,
        title: title ?? 'Something went wrong',
        type: ToastificationType.error,
        accent: AdminColors.error,
        icon: Icons.error_outline_rounded,
      );

  static void warning(BuildContext context, String message, {String? title}) =>
      _show(
        context,
        message: message,
        title: title ?? 'Heads up',
        type: ToastificationType.warning,
        accent: AdminColors.warning,
        icon: Icons.warning_amber_rounded,
      );

  static void info(BuildContext context, String message, {String? title}) =>
      _show(
        context,
        message: message,
        title: title ?? 'Info',
        type: ToastificationType.info,
        accent: AdminColors.info,
        icon: Icons.info_outline_rounded,
      );

  static void _show(
    BuildContext context, {
    required String message,
    required String title,
    required ToastificationType type,
    required Color accent,
    required IconData icon,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 450),
      animationBuilder: _animationBuilder,
      backgroundColor: AdminColors.surfaceElevated,
      foregroundColor: AdminColors.textPrimary,
      primaryColor: accent,
      icon: Icon(icon, color: accent),
      // Keep the toast compact instead of stretching full width.
      sizeConstraints: const BoxConstraints(minWidth: 280, maxWidth: 380),
      padding: const EdgeInsets.symmetric(
        horizontal: AdminDimensions.md,
        vertical: AdminDimensions.sm + 2,
      ),
      title: Text(
        title,
        style: AdminTextStyles.bodyMd(
          context,
        ).copyWith(fontWeight: FontWeight.w600),
      ),
      description: Text(
        message,
        softWrap: true,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: AdminTextStyles.bodySm(
          context,
        ).copyWith(color: AdminColors.textSecondary),
      ),
      borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
      borderSide: BorderSide(color: accent.withValues(alpha: 0.45), width: 1),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: accent.withValues(alpha: 0.15),
      ),
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      dragToClose: true,
      pauseOnHover: true,
      boxShadow: const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 20,
          offset: Offset(0, 6),
        ),
      ],
    );
  }

  /// Smooth entrance/exit: slide in from the left + fade + subtle scale,
  /// eased with [Curves.easeOutCubic] for a polished feel.
  static Widget _animationBuilder(
    BuildContext context,
    Animation<double> animation,
    Alignment alignment,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.25, 0),
          end: Offset.zero,
        ).animate(curved),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}
