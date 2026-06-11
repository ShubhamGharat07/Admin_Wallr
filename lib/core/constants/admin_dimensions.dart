// lib/core/constants/admin_dimensions.dart

import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

abstract final class AdminDimensions {
  // ── Static values (context nahi chahiye) ──────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double cardRadius = 12.0;
  static const double inputRadius = 8.0;
  static const double badgeRadius = 6.0;
  static const double buttonRadius = 8.0;
  static const double dialogRadius = 16.0;
  static const double chipRadius = 6.0;
  static const double avatarRadius = 20.0;

  static const double borderWidth = 1.0;

  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double inputHeight = 40.0;

  static const double tableRowHeight = 56.0;
  static const double tableHeaderHeight = 48.0;
  static const double thumbnailWidth = 40.0;
  static const double thumbnailHeight = 56.0;
  static const double thumbnailRadius = 4.0;

  static const double sidebarItemHeight = 44.0;
  static const double sidebarIconSize = 20.0;
  static const double sidebarLogoSize = 32.0;
  static const double sidebarCollapsed = 64.0;

  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  static const double statCardIconSize = 48.0;
  static const double contentMaxWidth = 1400.0;
  static const double topBarHeight = 64.0;

  // ── Breakpoints ───────────────────────────────────────────
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1200.0;

  // ── Responsive values (context chahiye) ───────────────────

  static double sidebarWidth(BuildContext context) =>
      ResponsiveHelper.sidebarWidth(context);

  static EdgeInsets contentPadding(BuildContext context) =>
      ResponsiveHelper.contentPadding(context);

  static double statCardHeight(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) return 100.0;
    return 120.0;
  }

  static double pageTitle(BuildContext context) =>
      ResponsiveHelper.fontSize(context, desktop: 24, tablet: 22, mobile: 18);

  static double sectionTitle(BuildContext context) =>
      ResponsiveHelper.fontSize(context, desktop: 18, tablet: 16, mobile: 15);

  static double gutter(BuildContext context) =>
      ResponsiveHelper.spacing(context, desktop: 24, tablet: 16, mobile: 12);
}
