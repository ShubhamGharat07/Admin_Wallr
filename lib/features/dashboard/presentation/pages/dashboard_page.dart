import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (context, t, child) => Opacity(opacity: t, child: child),
          child: const Text(
            'This is Dashboard',
            style: TextStyle(color: AdminColors.textSecondary, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
