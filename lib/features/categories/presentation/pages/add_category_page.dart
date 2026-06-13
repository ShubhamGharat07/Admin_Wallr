import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/injection.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../../../core/constants/admin_dimensions.dart';
import '../../../../core/constants/admin_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/admin_button.dart';
import '../../../../core/widgets/admin_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

// ─── Icon Options ─────────────────────────────────────────────────────────────

const _kIconOptions = <_IconOption>[
  _IconOption('category', Icons.category_outlined),
  _IconOption('landscape', Icons.landscape_outlined),
  _IconOption('architecture', Icons.architecture),
  _IconOption('color_lens', Icons.color_lens_outlined),
  _IconOption('pets', Icons.pets_outlined),
  _IconOption('directions_car', Icons.directions_car_outlined),
  _IconOption('sports_soccer', Icons.sports_soccer_outlined),
  _IconOption('music_note', Icons.music_note_outlined),
  _IconOption('local_florist', Icons.local_florist_outlined),
  _IconOption('nightlight', Icons.nightlight_outlined),
  _IconOption('wb_sunny', Icons.wb_sunny_outlined),
  _IconOption('science', Icons.science_outlined),
  _IconOption('temple_buddhist', Icons.temple_buddhist_outlined),
  _IconOption('flight', Icons.flight_outlined),
  _IconOption('water', Icons.water_outlined),
  _IconOption('forest', Icons.forest_outlined),
  _IconOption('castle', Icons.castle_outlined),
  _IconOption('auto_awesome', Icons.auto_awesome_outlined),
];

class _IconOption {
  final String name;
  final IconData icon;
  const _IconOption(this.name, this.icon);
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>(),
      child: const _AddCategoryView(),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────

class _AddCategoryView extends StatefulWidget {
  const _AddCategoryView();

  @override
  State<_AddCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<_AddCategoryView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _slugCtrl = TextEditingController();

  String _selectedIcon = 'category';
  bool _isActive = true;
  bool _isPremium = false;
  Uint8List? _coverImageBytes;
  String? _coverImageFileName;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_autoSlug);
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_autoSlug);
    _nameCtrl.dispose();
    _slugCtrl.dispose();
    super.dispose();
  }

  void _autoSlug() {
    final slug = _nameCtrl.text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
    _slugCtrl.text = slug;
  }

  Future<void> _pickCoverImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        setState(() {
          _coverImageBytes = file.bytes;
          _coverImageFileName = file.name;
        });
      }
    }
  }

  void _removeCover() => setState(() {
    _coverImageBytes = null;
    _coverImageFileName = null;
  });

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    context.read<CategoryBloc>().add(
      CategoryAddRequested(
        name: _nameCtrl.text.trim(),
        slug: _slugCtrl.text.trim(),
        iconName: _selectedIcon,
        isPremium: _isPremium,
        isActive: _isActive,
        coverImageBytes: _coverImageBytes != null
            ? List<int>.from(_coverImageBytes!)
            : null,
        coverImageFileName: _coverImageFileName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category added successfully!'),
              backgroundColor: AdminColors.successBg,
            ),
          );
          context.go(RouteNames.categories);
        } else if (state is CategoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AdminColors.errorBg,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AdminColors.background,
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryAdding) return const LoadingWidget();
            return _buildContent(context);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return SingleChildScrollView(
      padding: AdminDimensions.contentPadding(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PageHeader(),
            SizedBox(height: AdminDimensions.lg),

            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormCard(context),
                      SizedBox(height: AdminDimensions.lg),
                      _buildIconCard(context),
                      SizedBox(height: AdminDimensions.lg),
                      _buildCoverCard(context),
                      SizedBox(height: AdminDimensions.lg),
                      _buildToggleCard(context),
                      SizedBox(height: AdminDimensions.lg),
                      _buildActions(context, fullWidth: true),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            _buildFormCard(context),
                            SizedBox(height: AdminDimensions.lg),
                            _buildIconCard(context),
                            SizedBox(height: AdminDimensions.lg),
                            _buildCoverCard(context),
                          ],
                        ),
                      ),
                      SizedBox(width: AdminDimensions.lg),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildToggleCard(context),
                            SizedBox(height: AdminDimensions.lg),
                            _buildActions(context, fullWidth: false),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // ── Page Header ─────────────────────────────────────────────────────────────

  Widget _PageHeader() {
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.go(RouteNames.categories),
                  child: Text(
                    'Categories',
                    style: AdminTextStyles.bodyMd(
                      context,
                    ).copyWith(color: AdminColors.textTertiary),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AdminColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Add New',
                  style: AdminTextStyles.bodyMd(
                    context,
                  ).copyWith(color: AdminColors.gold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Add New Category',
              style: AdminTextStyles.headlineLg(context),
            ),
          ],
        );
      },
    );
  }

  // ── Form Card ───────────────────────────────────────────────────────────────

  Widget _buildFormCard(BuildContext context) {
    return _SectionCard(
      title: 'Category Details',
      icon: Icons.edit_outlined,
      child: Column(
        children: [
          AdminTextField(
            controller: _nameCtrl,
            hint: 'e.g. Abstract Landscapes',
            label: 'Category Name',
            validator: Validators.categoryName,
          ),
          SizedBox(height: AdminDimensions.md),
          AdminTextField(
            controller: _slugCtrl,
            hint: 'abstract-landscapes',
            label: 'URL Slug (auto-generated)',
            prefixIcon: Icons.link,
            validator: (v) => Validators.requiredField(v, 'Slug'),
          ),
        ],
      ),
    );
  }

  // ── Icon Card ───────────────────────────────────────────────────────────────

  Widget _buildIconCard(BuildContext context) {
    return _SectionCard(
      title: 'Category Icon',
      icon: Icons.interests_outlined,
      child: Wrap(
        spacing: AdminDimensions.sm,
        runSpacing: AdminDimensions.sm,
        children: _kIconOptions.map((option) {
          final isSelected = _selectedIcon == option.name;
          return GestureDetector(
            onTap: () => setState(() => _selectedIcon = option.name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? AdminColors.goldBg
                    : AdminColors.inputSurface,
                borderRadius: BorderRadius.circular(
                  AdminDimensions.inputRadius,
                ),
                border: Border.all(
                  color: isSelected ? AdminColors.gold : AdminColors.border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Tooltip(
                message: option.name,
                child: Icon(
                  option.icon,
                  size: 22,
                  color: isSelected
                      ? AdminColors.gold
                      : AdminColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Cover Card ──────────────────────────────────────────────────────────────

  Widget _buildCoverCard(BuildContext context) {
    return _SectionCard(
      title: 'Cover Image',
      icon: Icons.image_outlined,
      child: _coverImageBytes != null
          ? _buildCoverPreview(context)
          : _buildCoverDropzone(context),
    );
  }

  Widget _buildCoverDropzone(BuildContext context) {
    return GestureDetector(
      onTap: _pickCoverImage,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AdminColors.inputSurface,
          borderRadius: BorderRadius.circular(AdminDimensions.inputRadius),
          border: Border.all(color: AdminColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload icon circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AdminColors.goldBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.upload_outlined,
                color: AdminColors.gold,
                size: 26,
              ),
            ),
            SizedBox(height: AdminDimensions.sm + 4),
            Text(
              'Click to upload cover image',
              style: AdminTextStyles.bodyMd(
                context,
              ).copyWith(color: AdminColors.textSecondary),
            ),
            SizedBox(height: AdminDimensions.xs),
            Text(
              'JPG, PNG, WEBP  •  Optional',
              style: AdminTextStyles.bodySm(
                context,
              ).copyWith(color: AdminColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AdminDimensions.inputRadius),
          child: Image.memory(
            _coverImageBytes!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.check_circle,
              size: 16,
              color: AdminColors.success,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                _coverImageFileName ?? 'Image selected',
                style: AdminTextStyles.bodySmMuted(context),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: _removeCover,
              child: const Icon(
                Icons.close,
                size: 16,
                color: AdminColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Toggle Card ─────────────────────────────────────────────────────────────

  Widget _buildToggleCard(BuildContext context) {
    return _SectionCard(
      title: 'Visibility & Access',
      icon: Icons.visibility_outlined,
      child: Column(
        children: [
          _ToggleRow(
            label: 'Active Status',
            description: 'Publicly visible in the app',
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
          ),
          Divider(height: AdminDimensions.lg, color: AdminColors.border),
          _ToggleRow(
            label: 'Premium Only',
            description: 'Restrict to paid subscribers',
            value: _isPremium,
            onChanged: (v) => setState(() => _isPremium = v),
          ),
        ],
      ),
    );
  }

  // ── Actions ─────────────────────────────────────────────────────────────────

  Widget _buildActions(BuildContext context, {required bool fullWidth}) {
    return _SectionCard(
      title: 'Actions',
      icon: Icons.save_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminButton.primary(
            label: 'Save Category',
            onTap: _onSave,
            icon: Icons.check,
            width: double.infinity,
          ),
          SizedBox(height: AdminDimensions.sm),
          AdminButton.secondary(
            label: 'Discard',
            onTap: () => context.go(RouteNames.categories),
            icon: Icons.close,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AdminDimensions.md,
              vertical: AdminDimensions.sm + 4,
            ),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AdminColors.border)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AdminColors.gold),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: AdminTextStyles.labelMd(
                    context,
                  ).copyWith(color: AdminColors.gold, letterSpacing: 0.8),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(AdminDimensions.md),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── Toggle Row ───────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AdminTextStyles.bodyMd(
                  context,
                ).copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(description, style: AdminTextStyles.bodySmMuted(context)),
            ],
          ),
        ),
        // ── Fixed Toggle ───────────────────────────────────────
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: value ? AdminColors.gold : AdminColors.border,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? AdminColors.onGold : AdminColors.textTertiary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
