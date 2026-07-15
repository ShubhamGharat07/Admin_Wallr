import 'package:flutter/material.dart';
import '../constants/admin_colors.dart';
import '../constants/admin_text_styles.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;

  const LoadingWidget({super.key, this.message, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              color: AdminColors.gold,
              strokeWidth: 2.5,
              strokeCap: StrokeCap.round,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AdminTextStyles.bodyMd(context).copyWith(
                color: AdminColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
