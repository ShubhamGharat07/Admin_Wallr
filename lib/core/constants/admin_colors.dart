import 'package:flutter/material.dart';

abstract final class AdminColors {
  // ── Backgrounds & Surfaces ────────────────────────────────
  static const background = Color(0xFF0F0F0F);
  static const sidebar = Color(0xFF141414);
  static const surface = Color(0xFF1A1A1A);
  static const surfaceElevated = Color(0xFF1E1E1E);
  static const inputSurface = Color(0xFF222222);
  static const topBar = Color(0xFF141414);
  static const rowHover = Color(0xFF252525);
  static const tableHeader = Color(0xFF222222);

  // ── Borders ───────────────────────────────────────────────
  static const border = Color(0xFF2A2A2A);
  static const divider = Color(0xFF1F1F1F);

  // ── Text ──────────────────────────────────────────────────
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textTertiary = Color(0xFF6B7280);

  // ── Primary Gold ──────────────────────────────────────────
  static const gold = Color(0xFFF5C518);
  static const goldDim = Color(0xFFD4A017);
  static const goldBg = Color(0x1AF5C518); // 10% opacity
  static const onGold = Color(0xFF000000);

  // ── Status ────────────────────────────────────────────────
  static const success = Color(0xFF22C55E);
  static const successBg = Color(0xFF052E16);
  static const warning = Color(0xFFF59E0B);
  static const warningBg = Color(0xFF1C1107);
  static const error = Color(0xFFEF4444);
  static const errorBg = Color(0xFF1F0707);
  static const info = Color(0xFF3B82F6);
  static const infoBg = Color(0xFF030B1A);

  // ── Misc ──────────────────────────────────────────────────
  static const premium = Color(0xFFFFD700);
  static const premiumBg = Color(0xFF1A1400);
  static const free = Color(0xFF6B7280);
  static const freeBg = Color(0xFF1A1A1A);

  // ── Sidebar active state ──────────────────────────────────
  static const sidebarActiveBg = Color(
    0x1AF5C518,
  ); // secondary-container/20 equivalent
}
