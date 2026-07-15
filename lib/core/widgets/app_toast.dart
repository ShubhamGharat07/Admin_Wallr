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
        bgColor: const Color(0xFF1F3A1F),
        icon: Icons.check_circle_outline_rounded,
      );

  static void error(BuildContext context, String message, {String? title}) =>
      _show(
        context,
        message: message,
        title: title ?? 'Something went wrong',
        type: ToastificationType.error,
        accent: const Color(0xFFFF5252),
        bgColor: const Color(0xFF3A1F1F),
        icon: Icons.error_outline_rounded,
      );

  static void warning(BuildContext context, String message, {String? title}) =>
      _show(
        context,
        message: message,
        title: title ?? 'Heads up',
        type: ToastificationType.warning,
        accent: const Color(0xFFFFB74D),
        bgColor: const Color(0xFF3A2F1F),
        icon: Icons.warning_amber_rounded,
      );

  static void info(BuildContext context, String message, {String? title}) =>
      _show(
        context,
        message: message,
        title: title ?? 'Info',
        type: ToastificationType.info,
        accent: const Color(0xFF64B5F6),
        bgColor: const Color(0xFF1F2F3A),
        icon: Icons.info_outline_rounded,
      );

  static void _show(
    BuildContext context, {
    required String message,
    required String title,
    required ToastificationType type,
    required Color accent,
    required Color bgColor,
    required IconData icon,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 400),
      animationBuilder: _animationBuilder,
      backgroundColor: bgColor,
      foregroundColor: AdminColors.textPrimary,
      primaryColor: accent,
      icon: Icon(icon, color: accent, size: 20),
      sizeConstraints: const BoxConstraints(minWidth: 300, maxWidth: 400),
      padding: const EdgeInsets.symmetric(
        horizontal: AdminDimensions.md,
        vertical: AdminDimensions.sm + 4,
      ),
      title: Text(
        title,
        style: AdminTextStyles.bodyMd(context).copyWith(
          fontWeight: FontWeight.w600,
          color: accent,
        ),
      ),
      description: Text(
        message,
        softWrap: true,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: AdminTextStyles.bodySm(context).copyWith(
          color: AdminColors.textSecondary,
        ),
      ),
      borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
      borderSide: BorderSide(color: accent.withValues(alpha: 0.5), width: 1.5),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: accent.withValues(alpha: 0.2),
      ),
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      dragToClose: true,
      pauseOnHover: true,
      boxShadow: [
        BoxShadow(
          color: accent.withValues(alpha: 0.2),
          blurRadius: 16,
          offset: const Offset(0, 4),
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
