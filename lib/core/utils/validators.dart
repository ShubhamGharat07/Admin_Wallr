// lib/core/utils/validators.dart

abstract final class Validators {
  // ── Auth ──────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w.-]+@[\w-]+\.[a-z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Minimum 8 characters';
    return null;
  }

  // ── Wallpaper ─────────────────────────────────────────────
  static String? requiredField(String? value, [String label = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? wallpaperTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Title is required';
    if (value.trim().length < 3) return 'Minimum 3 characters';
    if (value.trim().length > 100) return 'Maximum 100 characters';
    return null;
  }

  // ── Category ──────────────────────────────────────────────
  static String? categoryName(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Category name is required';
    if (value.trim().length < 2) return 'Minimum 2 characters';
    if (value.trim().length > 50) return 'Maximum 50 characters';
    return null;
  }

  // ── Collection ────────────────────────────────────────────
  static String? collectionName(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Collection name is required';
    if (value.trim().length > 50) return 'Maximum 50 characters';
    return null;
  }

  // ── Announcement ─────────────────────────────────────────
  static String? announcementMessage(String? value) {
    if (value == null || value.trim().isEmpty) return 'Message is required';
    if (value.trim().length > 150) return 'Maximum 150 characters';
    return null;
  }

  // ── Notification ─────────────────────────────────────────
  static String? notifTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Title is required';
    if (value.trim().length > 65) return 'Maximum 65 characters';
    return null;
  }

  static String? notifBody(String? value) {
    if (value == null || value.trim().isEmpty) return 'Body is required';
    if (value.trim().length > 240) return 'Maximum 240 characters';
    return null;
  }

  // ── URL ───────────────────────────────────────────────────
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final regex = RegExp(r'^https?:\/\/.+\..+');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid URL (https://...)';
    return null;
  }

  // ── Slug ──────────────────────────────────────────────────
  static String toSlug(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
}
