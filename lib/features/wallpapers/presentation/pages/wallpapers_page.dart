import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';

class WallpapersPage extends StatelessWidget {
  const WallpapersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AdminColors.background,
      body: Center(
        child: Text(
          'This is Wallpapers',
          style: TextStyle(color: AdminColors.textSecondary, fontSize: 20),
        ),
      ),
    );
  }
}
