import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AdminColors.background,
      body: Center(
        child: Text(
          'This is Dashboard',
          style: TextStyle(color: AdminColors.textSecondary, fontSize: 20),
        ),
      ),
    );
  }
}
