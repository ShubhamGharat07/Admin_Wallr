import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';

class FeaturedPage extends StatelessWidget {
  const FeaturedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AdminColors.background,
      body: Center(
        child: Text(
          'This is Featured Content',
          style: TextStyle(color: AdminColors.textSecondary, fontSize: 20),
        ),
      ),
    );
  }
}
