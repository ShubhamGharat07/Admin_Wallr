// lib/core/theme/admin_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/admin_colors.dart';

abstract final class AdminTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AdminColors.background,
    primaryColor: AdminColors.gold,
    fontFamily: GoogleFonts.inter().fontFamily,

    // ColorScheme
    colorScheme: const ColorScheme.dark(
      primary: AdminColors.gold,
      onPrimary: AdminColors.onGold,
      surface: AdminColors.surface,
      onSurface: AdminColors.textPrimary,
      error: AdminColors.error,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AdminColors.topBar,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    // Card
    cardTheme: CardThemeData(
      color: AdminColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AdminColors.border),
      ),
      margin: EdgeInsets.zero,
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AdminColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AdminColors.inputSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AdminColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AdminColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AdminColors.gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AdminColors.error),
      ),
      hintStyle: const TextStyle(color: AdminColors.textTertiary),
    ),

    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AdminColors.gold,
        foregroundColor: AdminColors.onGold,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),

    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AdminColors.gold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Scrollbar always visible on web
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(AdminColors.border),
      trackColor: WidgetStateProperty.all(AdminColors.surface),
      radius: const Radius.circular(4),
      thickness: WidgetStateProperty.all(6),
      thumbVisibility: WidgetStateProperty.all(true),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AdminColors.gold;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AdminColors.onGold),
      side: const BorderSide(color: AdminColors.border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AdminColors.onGold;
        return AdminColors.textTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AdminColors.gold;
        return AdminColors.border;
      }),
    ),
  );
}
