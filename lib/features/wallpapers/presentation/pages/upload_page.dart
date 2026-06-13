import 'dart:math';
import 'dart:typed_data';
import 'package:device_frame/device_frame.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/di/injection.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../../../core/constants/admin_dimensions.dart';
import '../../../../core/constants/admin_text_styles.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/admin_button.dart';
import '../../../../core/widgets/admin_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_event.dart';
import '../../../categories/presentation/bloc/category_state.dart';
import '../bloc/wallpaper_bloc.dart';
import '../bloc/wallpaper_event.dart';
import '../bloc/wallpaper_state.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<CategoryBloc>()..add(const CategoriesLoadRequested()),
        ),
        BlocProvider(create: (_) => sl<WallpaperBloc>()),
      ],
      child: const _UploadView(),
    );
  }
}

class _UploadView extends StatefulWidget {
  const _UploadView();

  @override
  State<_UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<_UploadView> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();

  String? _selectedCategorySlug;
  final List<String> _tags = [];

  bool _isPremium = false;
  bool _isEditorChoice = false;
  bool _isActive = true;

  Uint8List? _imageBytes;
  String? _imageFileName;
  int? _imageWidth;
  int? _imageHeight;
  String? _imageResolution;
  String? _imageFormat;
  String? _fileSizeString;
  double? _imageAspectRatio;

  bool _previewIsLockScreen = true;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          final bytes = file.bytes!;
          final fileName = file.name;

          // Format from file extension
          final ext = fileName.split('.').last.toUpperCase();
          final format = ['JPG', 'JPEG', 'PNG', 'WEBP'].contains(ext)
              ? ext
              : 'JPEG';

          // Size formatting
          final sizeInMb = bytes.length / (1024 * 1024);
          final sizeString = '${sizeInMb.toStringAsFixed(2)} MB';

          // Decode dimensions using Flutter's native decodeImageFromList
          final decodedImage = await decodeImageFromList(bytes);

          setState(() {
            _imageBytes = bytes;
            _imageFileName = fileName;
            _imageFormat = format;
            _fileSizeString = sizeString;
            _imageWidth = decodedImage.width;
            _imageHeight = decodedImage.height;
            _imageAspectRatio = decodedImage.width / decodedImage.height;

            // Resolution category
            final maxDim = max(decodedImage.width, decodedImage.height);
            if (maxDim >= 3840) {
              _imageResolution = '4K';
            } else if (maxDim >= 2560) {
              _imageResolution = '2K';
            } else if (maxDim >= 1920) {
              _imageResolution = 'FHD';
            } else if (maxDim >= 1280) {
              _imageResolution = 'HD';
            } else {
              _imageResolution = 'SD';
            }
          });
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to pick/decode image',
        error: e,
        stackTrace: stackTrace,
        tag: 'UploadPage',
      );
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _imageBytes = null;
      _imageFileName = null;
      _imageFormat = null;
      _fileSizeString = null;
      _imageWidth = null;
      _imageHeight = null;
      _imageAspectRatio = null;
      _imageResolution = null;
    });
  }

  void _addTag() {
    final rawTag = _tagCtrl.text.trim();
    if (rawTag.isNotEmpty) {
      // Clean tags, remove special chars
      final cleanedTag = rawTag.toLowerCase().replaceAll(
        RegExp(r'[^a-zA-Z0-9-]'),
        '',
      );
      if (cleanedTag.isNotEmpty && !_tags.contains(cleanedTag)) {
        setState(() {
          _tags.add(cleanedTag);
          _tagCtrl.clear();
        });
      }
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _onPublish() {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a wallpaper image to upload.'),
          backgroundColor: AdminColors.errorBg,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategorySlug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
          backgroundColor: AdminColors.errorBg,
        ),
      );
      return;
    }

    context.read<WallpaperBloc>().add(
      WallpaperUploadRequested(
        title: _titleCtrl.text.trim(),
        category: _selectedCategorySlug!,
        tags: _tags,
        resolution: _imageResolution ?? 'HD',
        width: _imageWidth ?? 0,
        height: _imageHeight ?? 0,
        isPremium: _isPremium,
        isEditorChoice: _isEditorChoice,
        isActive: _isActive,
        imageBytes: _imageBytes!,
        fileName: _imageFileName!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WallpaperBloc, WallpaperState>(
      listener: (context, state) {
        if (state is WallpaperUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wallpaper uploaded successfully!'),
              backgroundColor: AdminColors.successBg,
            ),
          );
          context.go(RouteNames.wallpapers);
        } else if (state is WallpaperUploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed: ${state.message}'),
              backgroundColor: AdminColors.errorBg,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AdminColors.background,
        body: BlocBuilder<WallpaperBloc, WallpaperState>(
          builder: (context, state) {
            if (state is WallpaperUploading) {
              return const LoadingWidget();
            }
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
                      _buildUploadZone(context),
                      SizedBox(height: AdminDimensions.lg),
                      _buildMetadataCard(context),
                      SizedBox(height: AdminDimensions.lg),
                      _buildTogglesCard(context),
                      SizedBox(height: AdminDimensions.lg),
                      _buildPreviewCard(context),
                      SizedBox(height: AdminDimensions.lg),
                      _buildActionsCard(context, fullWidth: true),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side (60%): Forms & details
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            _buildUploadZone(context),
                            SizedBox(height: AdminDimensions.lg),
                            _buildMetadataCard(context),
                            SizedBox(height: AdminDimensions.lg),
                            _buildTogglesCard(context),
                          ],
                        ),
                      ),
                      SizedBox(width: AdminDimensions.lg),
                      // Right side (40%): Live Preview & Action
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildPreviewCard(context),
                            SizedBox(height: AdminDimensions.lg),
                            _buildActionsCard(context, fullWidth: false),
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
                  onTap: () => context.go(RouteNames.wallpapers),
                  child: Text(
                    'Wallpapers',
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
                  'Upload',
                  style: AdminTextStyles.bodyMd(
                    context,
                  ).copyWith(color: AdminColors.gold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Upload New Wallpaper',
              style: AdminTextStyles.headlineLg(context),
            ),
          ],
        );
      },
    );
  }

  // ── Media Source Upload Zone ────────────────────────────────────────────────

  Widget _buildUploadZone(BuildContext context) {
    return _SectionCard(
      title: 'Media Source',
      icon: Icons.cloud_upload_outlined,
      child: _imageBytes != null
          ? _buildSelectedImageDetails(context)
          : GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AdminColors.inputSurface,
                  borderRadius: BorderRadius.circular(
                    AdminDimensions.inputRadius,
                  ),
                  border: Border.all(color: AdminColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AdminColors.goldBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        color: AdminColors.gold,
                        size: 26,
                      ),
                    ),
                    SizedBox(height: AdminDimensions.sm + 4),
                    Text(
                      'Click to upload wallpaper image',
                      style: AdminTextStyles.bodyMd(
                        context,
                      ).copyWith(color: AdminColors.textSecondary),
                    ),
                    SizedBox(height: AdminDimensions.xs),
                    Text(
                      'JPG, PNG, WEBP (Minimum FHD Recommended)',
                      style: AdminTextStyles.bodySm(
                        context,
                      ).copyWith(color: AdminColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSelectedImageDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AdminDimensions.sm),
      decoration: BoxDecoration(
        color: AdminColors.inputSurface,
        borderRadius: BorderRadius.circular(AdminDimensions.inputRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AdminColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.memory(_imageBytes!, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: AdminDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _imageFileName ?? 'Selected File',
                  style: AdminTextStyles.bodyMd(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Format: ${_imageFormat ?? 'Unknown'}  •  Size: ${_fileSizeString ?? 'Unknown'}',
                  style: AdminTextStyles.bodySmMuted(context),
                ),
                if (_imageWidth != null && _imageHeight != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Dimensions: $_imageWidth × $_imageHeight px  •  Resolution: ${_imageResolution ?? 'Unknown'}',
                    style: AdminTextStyles.bodySmMuted(context),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AdminDimensions.sm),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AdminColors.error),
            onPressed: _removeSelectedImage,
          ),
        ],
      ),
    );
  }

  // ── Metadata Card ───────────────────────────────────────────────────────────

  Widget _buildMetadataCard(BuildContext context) {
    return _SectionCard(
      title: 'Metadata details',
      icon: Icons.edit_note_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminTextField(
            controller: _titleCtrl,
            hint: 'e.g. Neon Horizon',
            label: 'Wallpaper Title',
            validator: (val) => Validators.requiredField(val, 'Title'),
          ),
          SizedBox(height: AdminDimensions.md),
          _buildCategoryDropdown(context),
          SizedBox(height: AdminDimensions.md),
          _buildTagsField(context),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        List<DropdownMenuItem<String>> items = [];

        if (state is CategoryLoaded) {
          items = state.categories.map((c) {
            return DropdownMenuItem<String>(
              value: c.slug,
              child: Text(
                c.name,
                style: const TextStyle(color: AdminColors.textPrimary),
              ),
            );
          }).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: AdminTextStyles.labelMd(
                context,
              ).copyWith(color: AdminColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AdminColors.inputSurface,
                borderRadius: BorderRadius.circular(
                  AdminDimensions.inputRadius,
                ),
                border: Border.all(color: AdminColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategorySlug,
                  hint: Text(
                    'Select a category',
                    style: AdminTextStyles.bodyMd(
                      context,
                    ).copyWith(color: AdminColors.textTertiary),
                  ),
                  dropdownColor: AdminColors.surface,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AdminColors.textTertiary,
                  ),
                  items: items,
                  onChanged: (val) {
                    setState(() {
                      _selectedCategorySlug = val;
                    });
                  },
                  validator: (val) =>
                      val == null ? 'Category is required' : null,
                  style: AdminTextStyles.bodyMd(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTagsField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: AdminTextStyles.labelMd(
            context,
          ).copyWith(color: AdminColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: AdminTextField(
                controller: _tagCtrl,
                hint: 'Type a tag and press add',
                label: '',
                prefixIcon: Icons.local_offer_outlined,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.inputSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AdminDimensions.inputRadius,
                    ),
                    side: const BorderSide(color: AdminColors.border),
                  ),
                ),
                onPressed: _addTag,
                child: const Icon(Icons.add, color: AdminColors.gold),
              ),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags.map((tag) {
              return Chip(
                label: Text(tag, style: const TextStyle(fontSize: 12)),
                backgroundColor: AdminColors.surface,
                labelStyle: const TextStyle(color: AdminColors.gold),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 14,
                  color: AdminColors.error,
                ),
                onDeleted: () => _removeTag(tag),
                side: const BorderSide(color: AdminColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // ── Toggles Card ────────────────────────────────────────────────────────────

  Widget _buildTogglesCard(BuildContext context) {
    return _SectionCard(
      title: 'Visibility & Access',
      icon: Icons.lock_open_outlined,
      child: Column(
        children: [
          _ToggleRow(
            label: 'Active Status',
            description: 'Publicly visible in the application',
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
          ),
          Divider(height: AdminDimensions.lg, color: AdminColors.border),
          _ToggleRow(
            label: 'Premium Access',
            description: 'Restrict to paid subscribers',
            value: _isPremium,
            onChanged: (v) => setState(() => _isPremium = v),
          ),
          Divider(height: AdminDimensions.lg, color: AdminColors.border),
          _ToggleRow(
            label: 'Featured Wallpaper',
            description: 'Show under Editor\'s Choice',
            value: _isEditorChoice,
            onChanged: (v) => setState(() => _isEditorChoice = v),
          ),
        ],
      ),
    );
  }

  // ── Live Device Preview Card ────────────────────────────────────────────────

  Widget _buildPreviewCard(BuildContext context) {
    return _SectionCard(
      title: 'Live Preview',
      icon: Icons.smartphone_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildPreviewTabButton(
                  label: 'Lock Screen',
                  isActive: _previewIsLockScreen,
                  onTap: () => setState(() => _previewIsLockScreen = true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPreviewTabButton(
                  label: 'Home Screen',
                  isActive: !_previewIsLockScreen,
                  onTap: () => setState(() => _previewIsLockScreen = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 420,
            child: DeviceFrame(
              device: Devices.ios.iPhone13,
              isFrameVisible: true,
              orientation: Orientation.portrait,
              screen: _buildMockPhoneContent(context),
            ),
          ),
          const SizedBox(height: 20),
          _buildMetricsGrid(context),
        ],
      ),
    );
  }

  Widget _buildPreviewTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AdminColors.goldBg : AdminColors.inputSurface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? AdminColors.gold : AdminColors.border,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AdminTextStyles.bodyMd(context).copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? AdminColors.gold : AdminColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMockPhoneContent(BuildContext context) {
    return Container(
      color: AdminColors.background,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Selected image
          _imageBytes != null
              ? Image.memory(_imageBytes!, fit: BoxFit.cover)
              : Container(
                  color: const Color(0xFF151515),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: AdminColors.textTertiary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No image selected',
                        style: AdminTextStyles.bodySmMuted(context),
                      ),
                    ],
                  ),
                ),
          // Overlay mock interface
          _previewIsLockScreen
              ? _buildMockLockScreen()
              : _buildMockHomeScreen(),
        ],
      ),
    );
  }

  Widget _buildMockLockScreen() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Column(
              children: [
                const Icon(Icons.lock_outline, color: Colors.white, size: 20),
                const SizedBox(height: 6),
                const Text(
                  '09:41',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 48,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Wednesday, October 25',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLockScreenCircularButton(Icons.flashlight_on),
                _buildLockScreenCircularButton(Icons.camera_alt),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockScreenCircularButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.4),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildMockHomeScreen() {
    final mockApps = [
      {'icon': Icons.phone, 'label': 'Phone'},
      {'icon': Icons.chat_bubble_outline, 'label': 'Messages'},
      {'icon': Icons.mail_outline, 'label': 'Mail'},
      {'icon': Icons.camera_alt_outlined, 'label': 'Camera'},
      {'icon': Icons.map_outlined, 'label': 'Maps'},
      {'icon': Icons.photo_library_outlined, 'label': 'Photos'},
      {'icon': Icons.music_note, 'label': 'Music'},
      {'icon': Icons.settings_outlined, 'label': 'Settings'},
    ];

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockApps.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final app = mockApps[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          app['icon'] as IconData,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        app['label'] as String,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // Bottom Dock
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDockIcon(Icons.safety_check_sharp),
                _buildDockIcon(Icons.storefront_outlined),
                _buildDockIcon(Icons.videocam_outlined),
                _buildDockIcon(Icons.file_copy_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDockIcon(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                context,
                title: 'Original Res',
                value: _imageWidth != null && _imageHeight != null
                    ? '$_imageWidth × $_imageHeight'
                    : '—',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricItem(
                context,
                title: 'Aspect Ratio',
                value: _imageAspectRatio != null
                    ? _getAspectRatioLabel(_imageAspectRatio!)
                    : '—',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                context,
                title: 'File Size',
                value: _fileSizeString ?? '—',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricItem(
                context,
                title: 'Format',
                value: _imageFormat ?? '—',
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getAspectRatioLabel(double ratio) {
    // Round to common mobile/screen ratios
    if ((ratio - 9 / 16).abs() < 0.05) return '9:16';
    if ((ratio - 9 / 19.5).abs() < 0.05) return '9:19.5';
    if ((ratio - 9 / 18.5).abs() < 0.05) return '9:18.5';
    if ((ratio - 2 / 3).abs() < 0.05) return '2:3';
    if ((ratio - 3 / 4).abs() < 0.05) return '3:4';
    return ratio.toStringAsFixed(2);
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AdminColors.inputSurface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AdminColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AdminTextStyles.bodySmMuted(context)),
          const SizedBox(height: 2),
          Text(
            value,
            style: AdminTextStyles.bodyMd(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ── Actions Card ────────────────────────────────────────────────────────────

  Widget _buildActionsCard(BuildContext context, {required bool fullWidth}) {
    return _SectionCard(
      title: 'Actions',
      icon: Icons.save_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminButton.primary(
            label: 'Publish Wallpaper',
            onTap: _onPublish,
            icon: Icons.publish_outlined,
            width: double.infinity,
          ),
          SizedBox(height: AdminDimensions.sm),
          AdminButton.secondary(
            label: 'Discard',
            onTap: () => context.go(RouteNames.wallpapers),
            icon: Icons.close,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Card & Toggles ──────────────────────────────────────────────────

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
        // Toggle Switch
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
