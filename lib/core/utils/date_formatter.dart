// lib/core/utils/date_formatter.dart

import 'package:intl/intl.dart';

abstract final class DateFormatter {
  // ── Table display — "12 Jan 2025" ─────────────────────────
  static String tableDate(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);

  // ── Table with time — "12 Jan 2025, 3:45 PM" ─────────────
  static String tableDatetime(DateTime date) =>
      DateFormat('dd MMM yyyy, h:mm a').format(date);

  // ── Short — "Jan 2025" ────────────────────────────────────
  static String monthYear(DateTime date) => DateFormat('MMM yyyy').format(date);

  // ── Relative — "2 hours ago" / "3 days ago" ──────────────
  static String relative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  // ── Analytics chart label — "Jan", "Feb" ─────────────────
  static String chartMonth(DateTime date) => DateFormat('MMM').format(date);

  // ── Full — "Monday, 12 January 2025" ─────────────────────
  static String full(DateTime date) =>
      DateFormat('EEEE, dd MMMM yyyy').format(date);

  // ── Firestore timestamp input picker format ───────────────
  static String pickerDate(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  // ── From Firestore Timestamp → DateTime ──────────────────
  static DateTime fromTimestamp(dynamic ts) {
    if (ts == null) return DateTime.now();
    if (ts is DateTime) return ts;
    return ts.toDate(); // Firestore Timestamp
  }
}
