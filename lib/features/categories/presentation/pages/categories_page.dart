// // import 'package:flutter/material.dart';
// // import '../../../../core/constants/admin_colors.dart';

// // class CategoriesPage extends StatelessWidget {
// //   const CategoriesPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Scaffold(
// //       backgroundColor: AdminColors.background,
// //       body: Center(
// //         child: Text(
// //           'This is Categories',
// //           style: TextStyle(color: AdminColors.textSecondary, fontSize: 20),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // lib/features/categories/presentation/pages/categories_page.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/constants/admin_colors.dart';
// import '../../../../core/constants/admin_dimensions.dart';
// import '../../../../core/constants/admin_strings.dart';
// import '../../../../core/constants/admin_text_styles.dart';
// import '../../../../core/utils/responsive_helper.dart';
// import '../../../../core/widgets/admin_badge.dart';
// import '../../../../core/widgets/admin_button.dart';
// import '../../../../core/widgets/loading_widget.dart';
// import '../../domain/entities/category_entity.dart';
// import '../bloc/category_bloc.dart';
// import '../bloc/category_event.dart';
// import '../bloc/category_state.dart';

// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           context.read<CategoryBloc>()..add(const CategoriesLoadRequested()),
//       child: const _CategoriesView(),
//     );
//   }
// }

// class _CategoriesView extends StatelessWidget {
//   const _CategoriesView();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AdminColors.background,
//       body: Padding(
//         padding: AdminDimensions.contentPadding(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Header ──────────────────────────────────────
//             const _Header(),
//             SizedBox(height: AdminDimensions.lg),

//             // ── Table ───────────────────────────────────────
//             const Expanded(child: _CategoriesTable()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Header ───────────────────────────────────────────────────────────────────

// class _Header extends StatelessWidget {
//   const _Header({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         BlocBuilder<CategoryBloc, CategoryState>(
//           builder: (context, state) {
//             final count = state is CategoryLoaded
//                 ? '${state.categories.length} categories'
//                 : AdminStrings.categoriesTitle;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   AdminStrings.categoriesTitle,
//                   style: AdminTextStyles.headlineLg(context),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(count, style: AdminTextStyles.bodySmMuted(context)),
//               ],
//             );
//           },
//         ),
//         const Spacer(),
//         AdminButton.primary(
//           label: '+ ${AdminStrings.addCategory}',
//           onTap: () => _showAddCategoryDialog(context),
//           icon: null,
//         ),
//       ],
//     );
//   }

//   void _showAddCategoryDialog(BuildContext context) {
//     // TODO: Add category dialog — next step
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Add Category — Coming next!')),
//     );
//   }
// }

// // ─── Table ────────────────────────────────────────────────────────────────────

// class _CategoriesTable extends StatelessWidget {
//   const _CategoriesTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CategoryBloc, CategoryState>(
//       builder: (context, state) {
//         if (state is CategoryLoading) return const LoadingWidget();

//         if (state is CategoryError) {
//           return Center(
//             child: Text(
//               state.message,
//               style: AdminTextStyles.bodyMdMuted(context),
//             ),
//           );
//         }

//         if (state is CategoryLoaded && state.categories.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.category_outlined,
//                   size: 48,
//                   color: AdminColors.textTertiary,
//                 ),
//                 SizedBox(height: AdminDimensions.md),
//                 Text(
//                   'No categories yet',
//                   style: AdminTextStyles.headlineSm(context),
//                 ),
//                 const SizedBox(height: AdminDimensions.xs),
//                 Text(
//                   'Add your first category to get started',
//                   style: AdminTextStyles.bodyMdMuted(context),
//                 ),
//               ],
//             ),
//           );
//         }

//         final categories = state is CategoryLoaded
//             ? state.categories
//             : <CategoryEntity>[];

//         return Container(
//           decoration: BoxDecoration(
//             color: AdminColors.surface,
//             borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
//             border: Border.all(color: AdminColors.border),
//           ),
//           child: Column(
//             children: [
//               // Table header
//               const _TableHeader(),
//               Divider(height: 1, color: AdminColors.border),

//               // Table rows
//               Expanded(
//                 child: ReorderableListView.builder(
//                   itemCount: categories.length,
//                   onReorder: (oldIndex, newIndex) {
//                     if (newIndex > oldIndex) newIndex--;
//                     final reordered = List<CategoryEntity>.from(categories);
//                     final item = reordered.removeAt(oldIndex);
//                     reordered.insert(newIndex, item);
//                     context.read<CategoryBloc>().add(
//                       CategorySortOrderUpdated(
//                         reordered.map((c) => c.id).toList(),
//                       ),
//                     );
//                   },
//                   itemBuilder: (context, index) {
//                     final cat = categories[index];
//                     return _CategoryRow(
//                       key: ValueKey(cat.id),
//                       category: cat,
//                       isLast: index == categories.length - 1,
//                     );
//                   },
//                 ),
//               ),

//               // Footer
//               Divider(height: 1, color: AdminColors.border),
//               _TableFooter(count: categories.length),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // ─── Table Header ─────────────────────────────────────────────────────────────

// class _TableHeader extends StatelessWidget {
//   const _TableHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: AdminDimensions.tableHeaderHeight,
//       color: AdminColors.tableHeader,
//       padding: const EdgeInsets.symmetric(horizontal: AdminDimensions.md),
//       child: Row(
//         children: [
//           const SizedBox(width: 24), // drag handle space
//           SizedBox(width: AdminDimensions.sm),
//           Expanded(
//             flex: 4,
//             child: Text(
//               'CATEGORY',
//               style: AdminTextStyles.tableHeader(context),
//             ),
//           ),
//           // ✅ FIX: showTableExtras ki jagah showTableColumn use kiya hai
//           if (ResponsiveHelper.showTableColumn(context)) ...[
//             SizedBox(
//               width: 100,
//               child: Text(
//                 'COUNT',
//                 style: AdminTextStyles.tableHeader(context),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(
//               width: 100,
//               child: Text(
//                 'PREMIUM',
//                 style: AdminTextStyles.tableHeader(context),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//           SizedBox(
//             width: 100,
//             child: Text(
//               'STATUS',
//               style: AdminTextStyles.tableHeader(context),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(
//             width: 100,
//             child: Text(
//               'ACTIONS',
//               style: AdminTextStyles.tableHeader(context),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Category Row ─────────────────────────────────────────────────────────────

// class _CategoryRow extends StatelessWidget {
//   final CategoryEntity category;
//   final bool isLast;

//   const _CategoryRow({super.key, required this.category, required this.isLast});

//   Color _accentColor() {
//     try {
//       return Color(int.parse(category.accentColor.replaceFirst('#', '0xFF')));
//     } catch (_) {
//       return AdminColors.gold;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: AdminDimensions.tableRowHeight,
//           padding: const EdgeInsets.symmetric(horizontal: AdminDimensions.md),
//           decoration: BoxDecoration(
//             color: AdminColors.surface,
//             border: isLast
//                 ? null
//                 : const Border(bottom: BorderSide(color: AdminColors.border)),
//           ),
//           child: Row(
//             children: [
//               // Drag handle
//               Icon(
//                 Icons.drag_indicator,
//                 size: 20,
//                 color: AdminColors.textTertiary,
//               ),
//               SizedBox(width: AdminDimensions.sm),

//               // Category icon + name
//               Expanded(
//                 flex: 4,
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: _accentColor().withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.category_outlined,
//                         size: 18,
//                         color: _accentColor(),
//                       ),
//                     ),
//                     SizedBox(width: AdminDimensions.sm),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           category.name,
//                           style: AdminTextStyles.tableCell(
//                             context,
//                           ).copyWith(fontWeight: FontWeight.w600),
//                         ),
//                         Text(
//                           '/${category.slug}',
//                           style: AdminTextStyles.bodySmMuted(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // Count
//               // ✅ FIX: Yaha bhi showTableColumn use kiya hai
//               if (ResponsiveHelper.showTableColumn(context)) ...[
//                 SizedBox(
//                   width: 100,
//                   child: Text(
//                     '${category.wallpaperCount}',
//                     style: AdminTextStyles.tableCell(context),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),

//                 // Premium toggle
//                 SizedBox(
//                   width: 100,
//                   child: Center(
//                     child: Switch(
//                       value: category.isPremium,
//                       onChanged: (val) => context.read<CategoryBloc>().add(
//                         CategoryPremiumToggled(id: category.id, value: val),
//                       ),
//                       activeColor: AdminColors.gold,
//                     ),
//                   ),
//                 ),
//               ],

//               // Status badge
//               SizedBox(
//                 width: 100,
//                 child: Center(
//                   child: AdminBadge(
//                     label: category.isActive ? 'Active' : 'Hidden',
//                     type: category.isActive
//                         ? BadgeType.active
//                         : BadgeType.inactive,
//                   ),
//                 ),
//               ),

//               // Actions
//               SizedBox(
//                 width: 100,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Active toggle
//                     Switch(
//                       value: category.isActive,
//                       onChanged: (val) => context.read<CategoryBloc>().add(
//                         CategoryActiveToggled(id: category.id, value: val),
//                       ),
//                       activeColor: AdminColors.gold,
//                     ),

//                     // Delete
//                     InkWell(
//                       onTap: () => _confirmDelete(context),
//                       borderRadius: BorderRadius.circular(6),
//                       child: Padding(
//                         padding: const EdgeInsets.all(6),
//                         child: Icon(
//                           Icons.delete_outline,
//                           size: 18,
//                           color: AdminColors.error,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: AdminColors.surface,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AdminDimensions.dialogRadius),
//           side: const BorderSide(color: AdminColors.border),
//         ),
//         title: Text(
//           'Delete Category',
//           style: AdminTextStyles.headlineSm(context),
//         ),
//         content: Text(
//           'Delete "${category.name}"? This cannot be undone.',
//           style: AdminTextStyles.bodyMdMuted(context),
//         ),
//         actions: [
//           AdminButton.secondary(
//             label: AdminStrings.cancel,
//             onTap: () => Navigator.pop(context),
//           ),
//           AdminButton.danger(
//             label: AdminStrings.delete,
//             onTap: () {
//               context.read<CategoryBloc>().add(
//                 CategoryDeleteRequested(category.id),
//               );
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Table Footer ─────────────────────────────────────────────────────────────

// class _TableFooter extends StatelessWidget {
//   final int count;
//   const _TableFooter({super.key, required this.count});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48,
//       padding: const EdgeInsets.symmetric(horizontal: AdminDimensions.md),
//       child: Row(
//         children: [
//           Text(
//             'Showing 1-$count of $count categories',
//             style: AdminTextStyles.bodySmMuted(context),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/features/categories/presentation/pages/categories_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/injection.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../../../core/constants/admin_dimensions.dart';
import '../../../../core/constants/admin_strings.dart';
import '../../../../core/constants/admin_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/admin_badge.dart';
import '../../../../core/widgets/admin_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/category_entity.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(const CategoriesLoadRequested()),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: Padding(
        padding: AdminDimensions.contentPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            SizedBox(height: AdminDimensions.lg),
            const Expanded(child: _CategoriesTable()),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            final count = state is CategoryLoaded
                ? '${state.categories.length} categories'
                : AdminStrings.categoriesTitle;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AdminStrings.categoriesTitle,
                  style: AdminTextStyles.headlineLg(context),
                ),
                const SizedBox(height: 2),
                Text(count, style: AdminTextStyles.bodySmMuted(context)),
              ],
            );
          },
        ),
        const Spacer(),
        AdminButton.primary(
          label: '+ ${AdminStrings.addCategory}',
          onTap: () => _showAddCategoryDialog(context),
          icon: null,
        ),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Category — Coming next!')),
    );
  }
}

// ─── Table ────────────────────────────────────────────────────────────────────

class _CategoriesTable extends StatelessWidget {
  const _CategoriesTable();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) return const LoadingWidget();

        if (state is CategoryError) {
          return Center(
            child: Text(
              state.message,
              style: AdminTextStyles.bodyMdMuted(context),
            ),
          );
        }

        if (state is CategoryLoaded && state.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 48,
                  color: AdminColors.textTertiary,
                ),
                SizedBox(height: AdminDimensions.md),
                Text(
                  'No categories yet',
                  style: AdminTextStyles.headlineSm(context),
                ),
                const SizedBox(height: AdminDimensions.xs),
                Text(
                  'Add your first category to get started',
                  style: AdminTextStyles.bodyMdMuted(context),
                ),
              ],
            ),
          );
        }

        final categories = state is CategoryLoaded
            ? state.categories
            : <CategoryEntity>[];

        return Container(
          decoration: BoxDecoration(
            color: AdminColors.surface,
            borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
            border: Border.all(color: AdminColors.border),
          ),
          child: Column(
            children: [
              const _TableHeader(),
              Divider(height: 1, color: AdminColors.border),
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: categories.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    final reordered = List<CategoryEntity>.from(categories);
                    final item = reordered.removeAt(oldIndex);
                    reordered.insert(newIndex, item);
                    context.read<CategoryBloc>().add(
                      CategorySortOrderUpdated(
                        reordered.map((c) => c.id).toList(),
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return _CategoryRow(
                      key: ValueKey(cat.id),
                      category: cat,
                      isLast: index == categories.length - 1,
                    );
                  },
                ),
              ),
              Divider(height: 1, color: AdminColors.border),
              _TableFooter(count: categories.length),
            ],
          ),
        );
      },
    );
  }
}

// ─── Table Header ─────────────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminDimensions.tableHeaderHeight,
      color: AdminColors.tableHeader,
      padding: const EdgeInsets.symmetric(horizontal: AdminDimensions.md),
      child: Row(
        children: [
          const SizedBox(width: 24),
          SizedBox(width: AdminDimensions.sm),
          Expanded(
            flex: 4,
            child: Text(
              'CATEGORY',
              style: AdminTextStyles.tableHeader(context),
            ),
          ),
          if (ResponsiveHelper.showTableColumn(context)) ...[
            SizedBox(
              width: 100,
              child: Text(
                'COUNT',
                style: AdminTextStyles.tableHeader(context),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                'PREMIUM',
                style: AdminTextStyles.tableHeader(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          SizedBox(
            width: 100,
            child: Text(
              'STATUS',
              style: AdminTextStyles.tableHeader(context),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              'ACTIONS',
              style: AdminTextStyles.tableHeader(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Row ─────────────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  final CategoryEntity category;
  final bool isLast;

  const _CategoryRow({super.key, required this.category, required this.isLast});

  Color _accentColor() {
    try {
      return Color(int.parse(category.accentColor.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AdminColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AdminDimensions.tableRowHeight,
          padding: const EdgeInsets.symmetric(horizontal: AdminDimensions.md),
          decoration: BoxDecoration(
            color: AdminColors.surface,
            border: isLast
                ? null
                : const Border(bottom: BorderSide(color: AdminColors.border)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.drag_indicator,
                size: 20,
                color: AdminColors.textTertiary,
              ),
              SizedBox(width: AdminDimensions.sm),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _accentColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        size: 18,
                        color: _accentColor(),
                      ),
                    ),
                    SizedBox(width: AdminDimensions.sm),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: AdminTextStyles.tableCell(
                            context,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '/${category.slug}',
                          style: AdminTextStyles.bodySmMuted(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (ResponsiveHelper.showTableColumn(context)) ...[
                SizedBox(
                  width: 100,
                  child: Text(
                    '${category.wallpaperCount}',
                    style: AdminTextStyles.tableCell(context),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Switch(
                      value: category.isPremium,
                      onChanged: (val) => context.read<CategoryBloc>().add(
                        CategoryPremiumToggled(id: category.id, value: val),
                      ),
                      activeColor: AdminColors.gold,
                    ),
                  ),
                ),
              ],
              SizedBox(
                width: 100,
                child: Center(
                  child: AdminBadge(
                    label: category.isActive ? 'Active' : 'Hidden',
                    type: category.isActive
                        ? BadgeType.active
                        : BadgeType.inactive,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: category.isActive,
                      onChanged: (val) => context.read<CategoryBloc>().add(
                        CategoryActiveToggled(id: category.id, value: val),
                      ),
                      activeColor: AdminColors.gold,
                    ),
                    InkWell(
                      onTap: () => _confirmDelete(context),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AdminColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AdminColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminDimensions.dialogRadius),
          side: const BorderSide(color: AdminColors.border),
        ),
        title: Text(
          'Delete Category',
          style: AdminTextStyles.headlineSm(context),
        ),
        content: Text(
          'Delete "${category.name}"? This cannot be undone.',
          style: AdminTextStyles.bodyMdMuted(context),
        ),
        actions: [
          AdminButton.secondary(
            label: AdminStrings.cancel,
            onTap: () => Navigator.pop(context),
          ),
          AdminButton.danger(
            label: AdminStrings.delete,
            onTap: () {
              context.read<CategoryBloc>().add(
                CategoryDeleteRequested(category.id),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Table Footer ─────────────────────────────────────────────────────────────

class _TableFooter extends StatelessWidget {
  final int count;
  const _TableFooter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: AdminDimensions.md),
      child: Row(
        children: [
          Text(
            'Showing 1-$count of $count categories',
            style: AdminTextStyles.bodySmMuted(context),
          ),
        ],
      ),
    );
  }
}
