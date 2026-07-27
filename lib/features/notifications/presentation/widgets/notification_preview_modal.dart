import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../../../core/widgets/admin_button.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationPreviewModal extends StatelessWidget {
  final String title;
  final String body;
  final String? imageUrl;
  final TargetAudience targetAudience;

  const NotificationPreviewModal({
    super.key,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.targetAudience,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String body,
    String? imageUrl,
    required TargetAudience targetAudience,
  }) {
    return showDialog(
      context: context,
      builder: (context) => NotificationPreviewModal(
        title: title,
        body: body,
        imageUrl: imageUrl,
        targetAudience: targetAudience,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AdminColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Preview',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AdminColors.inputSurface,
                border: Border.all(color: AdminColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: AdminColors.border,
                            child: const Center(
                              child: Text(
                                'Image not found',
                                style: TextStyle(
                                  color: AdminColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      color: AdminColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    body,
                    style: const TextStyle(
                      color: AdminColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AdminColors.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AdminColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Audience: ${targetAudience.name}',
                      style: const TextStyle(
                        color: AdminColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdminButton.secondary(
                  label: 'Close',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
