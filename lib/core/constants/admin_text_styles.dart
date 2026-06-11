import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_colors.dart';

abstract final class AdminTextStyles {
  // ── Base Inter helper (private) ───────────────────────────
  static TextStyle _inter({
    required double size,
    required FontWeight weight,
    Color color = AdminColors.textPrimary,
    double? letterSpacing,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
  );

  // ── Responsive font size helper (private) ─────────────────
  static double _fs(
    BuildContext context, {
    required double desktop,
    required double tablet,
    required double mobile,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 768) return mobile;
    if (width < 1200) return tablet;
    return desktop;
  }

  // ── Display ───────────────────────────────────────────────
  static TextStyle display(BuildContext context) => _inter(
    size: _fs(context, desktop: 32, tablet: 28, mobile: 22),
    weight: FontWeight.w700,
    letterSpacing: -0.64,
  );

  // ── Headline ──────────────────────────────────────────────
  static TextStyle headlineLg(BuildContext context) => _inter(
    size: _fs(context, desktop: 24, tablet: 22, mobile: 18),
    weight: FontWeight.w600,
    letterSpacing: -0.24,
  );

  static TextStyle headlineMd(BuildContext context) => _inter(
    size: _fs(context, desktop: 20, tablet: 18, mobile: 16),
    weight: FontWeight.w600,
  );

  static TextStyle headlineSm(BuildContext context) => _inter(
    size: _fs(context, desktop: 18, tablet: 16, mobile: 15),
    weight: FontWeight.w600,
  );

  // ── Body ──────────────────────────────────────────────────
  static TextStyle bodyLg(BuildContext context) => _inter(
    size: _fs(context, desktop: 16, tablet: 15, mobile: 14),
    weight: FontWeight.w400,
  );

  static TextStyle bodyMd(BuildContext context) => _inter(
    size: _fs(context, desktop: 14, tablet: 14, mobile: 13),
    weight: FontWeight.w400,
  );

  static TextStyle bodySm(BuildContext context) => _inter(
    size: _fs(context, desktop: 12, tablet: 12, mobile: 11),
    weight: FontWeight.w400,
  );

  // ── Muted variants ────────────────────────────────────────
  static TextStyle bodyMdMuted(BuildContext context) =>
      bodyMd(context).copyWith(color: AdminColors.textSecondary);

  static TextStyle bodySmMuted(BuildContext context) =>
      bodySm(context).copyWith(color: AdminColors.textSecondary);

  static TextStyle bodySmTertiary(BuildContext context) =>
      bodySm(context).copyWith(color: AdminColors.textTertiary);

  // ── Label ─────────────────────────────────────────────────
  static TextStyle labelLg(BuildContext context) => _inter(
    size: _fs(context, desktop: 14, tablet: 13, mobile: 12),
    weight: FontWeight.w600,
    letterSpacing: 0.14,
  );

  static TextStyle labelMd(BuildContext context) => _inter(
    size: _fs(context, desktop: 12, tablet: 12, mobile: 11),
    weight: FontWeight.w500,
  );

  static TextStyle labelSm(BuildContext context) => _inter(
    size: _fs(context, desktop: 11, tablet: 11, mobile: 10),
    weight: FontWeight.w500,
  );

  // ── Table ─────────────────────────────────────────────────
  static TextStyle tableHeader(BuildContext context) => _inter(
    size: _fs(context, desktop: 12, tablet: 11, mobile: 11),
    weight: FontWeight.w600,
    color: AdminColors.textTertiary,
    letterSpacing: 0.6,
  );

  static TextStyle tableCell(BuildContext context) => _inter(
    size: _fs(context, desktop: 14, tablet: 13, mobile: 12),
    weight: FontWeight.w400,
  );

  // ── Sidebar ───────────────────────────────────────────────
  // Sidebar font size same rehta hai — collapsed me text hide ho jaata hai
  static TextStyle get sidebarItem => _inter(
    size: 14,
    weight: FontWeight.w500,
    color: AdminColors.textSecondary,
  );

  static TextStyle get sidebarItemActive =>
      _inter(size: 14, weight: FontWeight.w600, color: AdminColors.gold);

  // ── Stat Card ─────────────────────────────────────────────
  static TextStyle statValue(BuildContext context) => _inter(
    size: _fs(context, desktop: 28, tablet: 24, mobile: 20),
    weight: FontWeight.w700,
  );

  static TextStyle statLabel(BuildContext context) => _inter(
    size: _fs(context, desktop: 13, tablet: 12, mobile: 11),
    weight: FontWeight.w500,
    color: AdminColors.textSecondary,
  );

  static TextStyle statTrend(BuildContext context) => _inter(
    size: _fs(context, desktop: 12, tablet: 11, mobile: 11),
    weight: FontWeight.w500,
  );
}
