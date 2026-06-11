// lib/core/utils/responsive_helper.dart

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

abstract final class ResponsiveHelper {
  // ── Breakpoint checks ─────────────────────────────────────
  static bool isMobile(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile;

  static bool isTablet(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isTablet;

  static bool isDesktop(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isDesktop;

  // ── Sidebar ───────────────────────────────────────────────
  static double sidebarWidth(BuildContext context) {
    if (isMobile(context)) return 0;
    if (isTablet(context)) return 64;
    return 260;
  }

  static bool showSidebar(BuildContext context) => !isMobile(context);
  static bool isSidebarCollapsed(BuildContext context) => isTablet(context);

  // ── Content Padding ───────────────────────────────────────
  static EdgeInsets contentPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(12);
    if (isTablet(context)) return const EdgeInsets.all(16);
    return const EdgeInsets.all(32);
  }

  // ── Stat Cards Grid ───────────────────────────────────────
  // Dashboard me 4 stat cards — columns adjust hote hain
  static int statCardColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 2;
    return 4;
  }

  // ── Generic Grid Columns ──────────────────────────────────
  static int gridColumns(
    BuildContext context, {
    int desktop = 4,
    int tablet = 2,
    int mobile = 1,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // ── Font Sizes ────────────────────────────────────────────
  static double fontSize(
    BuildContext context, {
    required double desktop,
    required double tablet,
    required double mobile,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // ── Spacing ───────────────────────────────────────────────
  static double spacing(
    BuildContext context, {
    required double desktop,
    required double tablet,
    required double mobile,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // ── Dialog Width ──────────────────────────────────────────
  static double dialogWidth(BuildContext context) {
    if (isMobile(context)) return MediaQuery.sizeOf(context).width * 0.95;
    if (isTablet(context)) return 520;
    return 600;
  }

  // ── Table: show/hide columns ──────────────────────────────
  // Mobile me kuch columns hide karo
  static bool showTableColumn(BuildContext context) => !isMobile(context);
}
