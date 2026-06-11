// lib/core/widgets/stat_card.dart

import 'package:flutter/material.dart';
import '../constants/admin_colors.dart';
import '../constants/admin_dimensions.dart';
import '../constants/admin_text_styles.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String? trend; // e.g. "+12%"
  final bool trendUp;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.trend,
    this.trendUp = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminDimensions.statCardHeight(context),
      padding: const EdgeInsets.all(AdminDimensions.md),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top row — label + icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AdminTextStyles.statLabel(context)),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AdminColors.goldBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: AdminDimensions.iconMd,
                  color: iconColor ?? AdminColors.gold,
                ),
              ),
            ],
          ),

          // Bottom row — value + trend
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AdminTextStyles.statValue(context)),
              if (trend != null) ...[
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: trendUp ? AdminColors.success : AdminColors.error,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend!,
                      style: AdminTextStyles.statTrend(context).copyWith(
                        color: trendUp
                            ? AdminColors.success
                            : AdminColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
