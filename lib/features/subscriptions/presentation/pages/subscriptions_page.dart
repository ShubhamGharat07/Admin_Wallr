import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AdminColors.background,
      body: Center(
        child: Text(
          'This is Subscriptions',
          style: TextStyle(color: AdminColors.textSecondary, fontSize: 20),
        ),
      ),
    );
  }
}
