// // lib/core/widgets/admin_topbar.dart

// import 'package:flutter/material.dart';
// import '../constants/admin_colors.dart';
// import '../constants/admin_dimensions.dart';
// import '../constants/admin_text_styles.dart';
// import '../utils/responsive_helper.dart';

// class AdminTopBar extends StatelessWidget {
//   final String title;
//   final List<Widget>? actions;
//   final VoidCallback? onMenuTap; // mobile drawer toggle

//   const AdminTopBar({
//     super.key,
//     required this.title,
//     this.actions,
//     this.onMenuTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: AdminDimensions.topBarHeight,
//       decoration: const BoxDecoration(
//         color: AdminColors.topBar,
//         border: Border(bottom: BorderSide(color: AdminColors.border)),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: AdminDimensions.md),
//       child: Row(
//         children: [
//           // Hamburger — mobile only
//           if (ResponsiveHelper.isMobile(context)) ...[
//             IconButton(
//               onPressed: onMenuTap,
//               icon: const Icon(
//                 Icons.menu,
//                 color: AdminColors.textSecondary,
//                 size: AdminDimensions.iconMd,
//               ),
//             ),
//             const SizedBox(width: AdminDimensions.sm),
//           ],

//           // Page title
//           Text(title, style: AdminTextStyles.headlineMd(context)),

//           const Spacer(),

//           // Actions
//           if (actions != null)
//             ...actions!.map(
//               (a) => Padding(
//                 padding: const EdgeInsets.only(left: AdminDimensions.sm),
//                 child: a,
//               ),
//             ),

//           const SizedBox(width: AdminDimensions.sm),

//           // Notification icon
//           _TopBarIcon(icon: Icons.notifications_outlined, onTap: () {}),

//           const SizedBox(width: AdminDimensions.xs),

//           // Settings icon
//           _TopBarIcon(icon: Icons.settings_outlined, onTap: () {}),
//         ],
//       ),
//     );
//   }
// }

// class _TopBarIcon extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;

//   const _TopBarIcon({required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: 36,
//         height: 36,
//         decoration: BoxDecoration(
//           border: Border.all(color: AdminColors.border),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           icon,
//           size: AdminDimensions.iconMd,
//           color: AdminColors.textSecondary,
//         ),
//       ),
//     );
//   }
// }

// lib/core/widgets/admin_topbar.dart

import 'package:flutter/material.dart';
import '../constants/admin_colors.dart';
import '../constants/admin_dimensions.dart';
import '../constants/admin_text_styles.dart';
import '../utils/responsive_helper.dart';

class AdminTopBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onMenuTap;

  const AdminTopBar({
    super.key,
    required this.title,
    this.actions,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminDimensions.topBarHeight,
      decoration: BoxDecoration(
        color: AdminColors.topBar,
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AdminDimensions.md),
      child: Row(
        children: [
          // Hamburger — mobile only
          if (ResponsiveHelper.isMobile(context)) ...[
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(
                Icons.menu,
                color: AdminColors.textSecondary,
                size: AdminDimensions.iconMd,
              ),
            ),
            const SizedBox(width: AdminDimensions.sm),
          ],

          // Page title
          Text(title, style: AdminTextStyles.headlineMd(context)),

          const Spacer(),

          // Custom actions
          if (actions != null)
            ...actions!.map(
              (a) => Padding(
                padding: const EdgeInsets.only(left: AdminDimensions.sm),
                child: a,
              ),
            ),

          const SizedBox(width: AdminDimensions.sm),

          // Notification icon
          _IconBtn(icon: Icons.notifications_outlined, onTap: () {}),
          const SizedBox(width: AdminDimensions.xs),

          // Settings icon
          _IconBtn(icon: Icons.settings_outlined, onTap: () {}),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AdminColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: AdminDimensions.iconMd,
          color: AdminColors.textSecondary,
        ),
      ),
    );
  }
}
