import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AdminColors.background,
      body: Center(
        child: Text(
          'This is Notifications',
          style: TextStyle(color: AdminColors.textSecondary, fontSize: 20),
        ),
      ),
    );
  }
}
