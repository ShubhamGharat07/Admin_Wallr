// lib/features/wallpapers/presentation/pages/wallpapers_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../config/di/injection.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../../../core/constants/admin_dimensions.dart';
import '../../../../core/constants/admin_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/admin_badge.dart';
import '../../../../core/widgets/admin_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/wallpaper_entity.dart';
import '../bloc/wallpaper_bloc.dart';
import '../bloc/wallpaper_event.dart';
import '../bloc/wallpaper_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Page Entry
// ─────────────────────────────────────────────────────────────────────────────

class WallpapersPage extends StatefulWidget {
  const WallpapersPage({super.key});

  @override
  State<WallpapersPage> createState() => _WallpapersPageState();
}

class _WallpapersPageState extends State<WallpapersPage> {
  // ── Filter state ─────────────────────────────────────────
  String? _selectedCategory;
  String? _selectedStatus; // 'published' | 'pending' | 'rejected' | null
  String? _selectedTier;   // 'premium' | 'free' | null

  // ── Selection & view ────────────────────────────────────
  WallpaperEntity? _selectedWallpaper;
  bool _isGridView = false;

  // ── Pagination ──────────────────────────────────────────
  int _currentPage = 0;
  static const int _pageSize = 10;

  // ── Live data ───────────────────────────────────────────
  List<WallpaperEntity> _all = [];
  bool _loading = true;
  String? _error;

  // ── Delete state ────────────────────────────────────────
  String? _deletingId;
  late WallpaperBloc _wallpaperBloc;

  @override
  void initState() {
    super.initState();
    _wallpaperBloc = sl<WallpaperBloc>();
    _fetchWallpapers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchWallpapers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final snap = await FirebaseFirestore.instance
          .collection('wallpapers')
          .orderBy('createdAt', descending: true)
          .get();
      final list = snap.docs.map((d) {
        final data = d.data();
        return WallpaperEntity(
          id: d.id,
          title: data['title'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          thumbnailUrl: data['thumbnailUrl'] ?? '',
          publicId: data['publicId'] ?? '',
          category: data['category'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
          resolution: data['resolution'] ?? '',
          width: (data['width'] ?? 0) as int,
          height: (data['height'] ?? 0) as int,
          isPremium: data['isPremium'] ?? false,
          isActive: data['isActive'] ?? false,
          isEditorChoice: data['isEditorChoice'] ?? false,
          isTrendingPinned: data['isTrendingPinned'] ?? false,
          downloadCount: (data['downloadCount'] ?? 0) as int,
          viewCount: (data['viewCount'] ?? 0) as int,
          uploadedBy: data['uploadedBy'] ?? '',
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
      setState(() {
        _all = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // ── Derived: filtered list ───────────────────────────────
  List<WallpaperEntity> get _filtered {
    return _all.where((w) {
      if (_selectedCategory != null &&
          w.category.toLowerCase() != _selectedCategory!.toLowerCase()) {
        return false;
      }
      if (_selectedStatus != null) {
        final status = _wallpaperStatus(w);
        if (status.toLowerCase() != _selectedStatus!.toLowerCase()) return false;
      }
      if (_selectedTier != null) {
        if (_selectedTier == 'premium' && !w.isPremium) return false;
        if (_selectedTier == 'free' && w.isPremium) return false;
      }
      return true;
    }).toList();
  }

  List<WallpaperEntity> get _paged {
    final f = _filtered;
    final start = _currentPage * _pageSize;
    if (start >= f.length) return [];
    return f.sublist(start, (start + _pageSize).clamp(0, f.length));
  }

  int get _totalPages => (_filtered.length / _pageSize).ceil();

  String _wallpaperStatus(WallpaperEntity w) {
    if (w.isActive) return 'Published';
    // Check if it has been explicitly rejected (we use isEditorChoice=false & isActive=false heuristic)
    return 'Rejected';
  }

  List<String> get _categories {
    return _all.map((w) => w.category).toSet().toList()..sort();
  }

  // ── Update wallpaper status in Firestore ────────────────
  Future<void> _setStatus(String id, String status) async {
    try {
      final isActive = status == 'Published';
      await FirebaseFirestore.instance
          .collection('wallpapers')
          .doc(id)
          .update({'isActive': isActive});
      await _fetchWallpapers();
      // refresh selected if it's the same
      if (_selectedWallpaper?.id == id) {
        setState(() {
          _selectedWallpaper = _all.firstWhere(
            (w) => w.id == id,
            orElse: () => _selectedWallpaper!,
          );
        });
      }
      if (mounted) {
        AppToast.success(context, 'Wallpaper status updated to $status.');
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(context, 'Failed to update status: $e');
      }
    }
  }

  Future<void> _toggleFeature(String id, bool value) async {
    try {
      await FirebaseFirestore.instance
          .collection('wallpapers')
          .doc(id)
          .update({'isEditorChoice': value});
      await _fetchWallpapers();
      // refresh selected if it's the same
      if (_selectedWallpaper?.id == id) {
        setState(() {
          _selectedWallpaper = _all.firstWhere(
            (w) => w.id == id,
            orElse: () => _selectedWallpaper!,
          );
        });
      }
      if (mounted) {
        AppToast.success(
          context,
          value ? 'Wallpaper featured.' : 'Wallpaper unfeatured.',
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(context, 'Failed to update feature status: $e');
      }
    }
  }

  Future<void> _delete(String id) async {
    final wallpaper = _all.firstWhere((w) => w.id == id, orElse: () => WallpaperEntity(id: id, title: 'Unknown', imageUrl: '', thumbnailUrl: '', publicId: '', category: '', tags: [], resolution: '', width: 0, height: 0, isPremium: false, isActive: false, isEditorChoice: false, isTrendingPinned: false, downloadCount: 0, viewCount: 0, uploadedBy: '', createdAt: DateTime.now()));

    setState(() => _deletingId = id);

    _wallpaperBloc.add(
      WallpaperDeleteRequested(
        wallpaperId: id,
        title: wallpaper.title,
        category: wallpaper.category,
        publicId: wallpaper.publicId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return BlocListener<WallpaperBloc, WallpaperState>(
      bloc: _wallpaperBloc,
      listener: (context, state) {
        if (state is WallpaperDeleteSuccess) {
          setState(() => _deletingId = null);
          if (_selectedWallpaper?.id == state.wallpaperId) {
            Navigator.of(context, rootNavigator: true).maybePop();
            setState(() => _selectedWallpaper = null);
          }
          setState(() => _all.removeWhere((w) => w.id == state.wallpaperId));
          if (mounted) {
            AppToast.success(context, 'Wallpaper deleted successfully');
          }
        } else if (state is WallpaperDeleteError) {
          setState(() => _deletingId = null);
          if (mounted) {
            AppToast.error(context, 'Failed to delete: ${state.message}');
          }
        }
      },
      child: Scaffold(
        backgroundColor: AdminColors.background,
        body: Padding(
        padding: AdminDimensions.contentPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            _Header(
              total: _all.length,
              onRefresh: _fetchWallpapers,
            ),
            SizedBox(height: AdminDimensions.gutter(context)),

            // ── Filter Bar ──
            _FilterBar(
              categories: _categories,
              selectedCategory: _selectedCategory,
              selectedStatus: _selectedStatus,
              selectedTier: _selectedTier,
              isGridView: _isGridView,
              onCategoryChanged: (v) => setState(() {
                _selectedCategory = v;
                _currentPage = 0;
              }),
              onStatusChanged: (v) => setState(() {
                _selectedStatus = v;
                _currentPage = 0;
              }),
              onTierChanged: (v) => setState(() {
                _selectedTier = v;
                _currentPage = 0;
              }),
              onClearFilters: () => setState(() {
                _selectedCategory = null;
                _selectedStatus = null;
                _selectedTier = null;
                _currentPage = 0;
              }),
              onToggleView: () => setState(() => _isGridView = !_isGridView),
            ),
            SizedBox(height: AdminDimensions.gutter(context)),

            // ── Main body ──
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: AdminColors.gold))
                  : _error != null
                      ? Center(
                          child: Text(
                            _error!,
                            style: AdminTextStyles.bodyMdMuted(context),
                          ),
                        )
                      : !isMobile && _selectedWallpaper != null
                          // Tablet & Desktop: table/grid + right details panel
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _WallpapersTable(
                                    wallpapers: _paged,
                                    allFiltered: _filtered,
                                    currentPage: _currentPage,
                                    totalPages: _totalPages,
                                    pageSize: _pageSize,
                                    selectedId: _selectedWallpaper?.id,
                                    isGridView: _isGridView,
                                    wallpaperStatus: _wallpaperStatus,
                                    onSelect: (w) =>
                                        setState(() => _selectedWallpaper = w),
                                    onPageChange: (p) =>
                                        setState(() => _currentPage = p),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color: AdminColors.surface,
                                    borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
                                    border: Border.all(color: AdminColors.border),
                                  ),
                                  child: _SidePanel(
                                    wallpaper: _selectedWallpaper!,
                                    wallpaperStatus: _wallpaperStatus,
                                    onSetStatus: _setStatus,
                                    onToggleFeature: _toggleFeature,
                                    onDelete: _delete,
                                    deletingId: _deletingId,
                                    onClose: () => setState(() => _selectedWallpaper = null),
                                  ),
                                ),
                              ],
                            )
                          // Mobile or no wallpaper selected: full width table/grid
                          : _WallpapersTable(
                              wallpapers: _paged,
                              allFiltered: _filtered,
                              currentPage: _currentPage,
                              totalPages: _totalPages,
                              pageSize: _pageSize,
                              selectedId: _selectedWallpaper?.id,
                              isGridView: _isGridView,
                              wallpaperStatus: _wallpaperStatus,
                              onSelect: (w) {
                                setState(() => _selectedWallpaper = w);
                                // On mobile: show bottom sheet
                                if (isMobile && w != null) {
                                  _showDetailSheet(context, w);
                                }
                              },
                              onPageChange: (p) =>
                                  setState(() => _currentPage = p),
                            ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, WallpaperEntity w) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AdminColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, sc) => _SidePanel(
          wallpaper: w,
          wallpaperStatus: _wallpaperStatus,
          onSetStatus: _setStatus,
          onToggleFeature: _toggleFeature,
          onDelete: _delete,
          deletingId: _deletingId,
          onClose: () => Navigator.pop(context),
          scrollController: sc,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final int total;
  final VoidCallback onRefresh;
  const _Header({required this.total, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text('Wallpapers', style: AdminTextStyles.headlineLg(context)),
            const SizedBox(width: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AdminColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AdminColors.border),
              ),
              child: Text(
                '$total total',
                style: AdminTextStyles.labelSm(context)
                    .copyWith(color: AdminColors.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Manage, moderate, and publish wallpaper content across the platform.',
          style: AdminTextStyles.bodySmMuted(context),
        ),
      ],
    );

    final exportBtn = AdminButton.secondary(
      label: 'Export',
      icon: Icons.file_download_outlined,
      onTap: () {},
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleBlock,
          SizedBox(height: AdminDimensions.sm),
          exportBtn,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: titleBlock),
        exportBtn,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Bar
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final String? selectedStatus;
  final String? selectedTier;
  final bool isGridView;

  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onTierChanged;
  final VoidCallback onClearFilters;
  final VoidCallback onToggleView;

  const _FilterBar({
    required this.categories,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.selectedTier,
    required this.isGridView,
    required this.onCategoryChanged,
    required this.onStatusChanged,
    required this.onTierChanged,
    required this.onClearFilters,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final filters = <Widget>[
      _DropdownFilter(
        hint: 'Categories',
        value: selectedCategory,
        items: categories,
        onChanged: onCategoryChanged,
      ),
      const SizedBox(width: 8),
      _DropdownFilter(
        hint: 'Status',
        value: selectedStatus,
        items: const ['Published', 'Rejected'],
        onChanged: onStatusChanged,
      ),
      const SizedBox(width: 8),
      _DropdownFilter(
        hint: 'All Tiers',
        value: selectedTier,
        items: const ['premium', 'free'],
        itemLabels: const ['Premium', 'Free'],
        onChanged: onTierChanged,
      ),
      const SizedBox(width: 8),
      TextButton(
        onPressed: onClearFilters,
        child: Text('Clear', style: AdminTextStyles.labelMd(context)
            .copyWith(color: AdminColors.textSecondary)),
      ),
    ];

    final viewToggle = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ViewToggleBtn(
          icon: Icons.table_rows_outlined,
          active: !isGridView,
          onTap: () { if (isGridView) onToggleView(); },
        ),
        const SizedBox(width: 4),
        _ViewToggleBtn(
          icon: Icons.grid_view_rounded,
          active: isGridView,
          onTap: () { if (!isGridView) onToggleView(); },
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 0,
                  runSpacing: 8,
                  children: filters,
                ),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: viewToggle),
              ],
            )
          : Row(
              children: [
                ...filters,
                const Spacer(),
                viewToggle,
              ],
            ),
    );
  }
}

class _DropdownFilter extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final List<String>? itemLabels;
  final ValueChanged<String?> onChanged;

  const _DropdownFilter({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AdminColors.inputSurface,
        borderRadius: BorderRadius.circular(AdminDimensions.inputRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          hint: Text(
            hint,
            style: AdminTextStyles.labelMd(context)
                .copyWith(color: AdminColors.textSecondary),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AdminColors.textSecondary, size: 16),
          dropdownColor: AdminColors.surface,
          isDense: true,
          style: AdminTextStyles.labelMd(context),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(hint,
                  style: AdminTextStyles.labelMd(context)
                      .copyWith(color: AdminColors.textSecondary)),
            ),
            ...items.asMap().entries.map((e) {
              final label = itemLabels != null ? itemLabels![e.key] : e.value;
              return DropdownMenuItem<String?>(
                value: e.value,
                child: Text(label,
                    style: AdminTextStyles.labelMd(context)
                        .copyWith(color: AdminColors.textPrimary)),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ViewToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _ViewToggleBtn(
      {required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: active ? AdminColors.goldBg : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: active ? AdminColors.gold : AdminColors.border,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? AdminColors.gold : AdminColors.textSecondary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Wallpapers Table / Grid
// ─────────────────────────────────────────────────────────────────────────────

class _WallpapersTable extends StatelessWidget {
  final List<WallpaperEntity> wallpapers;
  final List<WallpaperEntity> allFiltered;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final String? selectedId;
  final bool isGridView;
  final String Function(WallpaperEntity) wallpaperStatus;
  final ValueChanged<WallpaperEntity?> onSelect;
  final ValueChanged<int> onPageChange;

  const _WallpapersTable({
    required this.wallpapers,
    required this.allFiltered,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.selectedId,
    required this.isGridView,
    required this.wallpaperStatus,
    required this.onSelect,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    if (allFiltered.isEmpty) {
      return _EmptyState();
    }

    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: Column(
        children: [
          // ── Header row ──
          if (!isGridView)
            _WallpaperTableHeader(isTablet: isTablet),

          // ── Rows / Grid ──
          Expanded(
            child: isGridView
                ? _GridBody(
                    wallpapers: wallpapers,
                    selectedId: selectedId,
                    wallpaperStatus: wallpaperStatus,
                    onSelect: onSelect,
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: wallpapers.length,
                    itemBuilder: (ctx, i) {
                      final w = wallpapers[i];
                      return _WallpaperRow(
                        wallpaper: w,
                        isLast: i == wallpapers.length - 1,
                        isSelected: w.id == selectedId,
                        status: wallpaperStatus(w),
                        isTablet: isTablet,
                        onTap: () => onSelect(w),
                      );
                    },
                  ),
          ),

          // ── Footer / Pagination ──
          Divider(height: 1, color: AdminColors.border),
          _TableFooter(
            currentPage: currentPage,
            totalPages: totalPages,
            pageSize: pageSize,
            totalItems: allFiltered.length,
            onPageChange: onPageChange,
          ),
        ],
      ),
    );
  }
}

// ── Table header row ─────────────────────────────────────────────────────────

class _WallpaperTableHeader extends StatelessWidget {
  final bool isTablet;
  const _WallpaperTableHeader({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminDimensions.tableHeaderHeight,
      color: AdminColors.tableHeader,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const SizedBox(width: 28), // checkbox col
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Text('WALLPAPER',
                style: AdminTextStyles.tableHeader(context)),
          ),
          if (!isTablet) ...[
            SizedBox(
              width: 100,
              child: Text('CATEGORY',
                  style: AdminTextStyles.tableHeader(context)),
            ),
            SizedBox(
              width: 60,
              child: Text('TIER',
                  style: AdminTextStyles.tableHeader(context),
                  textAlign: TextAlign.center),
            ),
          ],
          SizedBox(
            width: 100,
            child: Text('STATUS',
                style: AdminTextStyles.tableHeader(context),
                textAlign: TextAlign.center),
          ),
          SizedBox(
            width: 90,
            child: Text('STATS',
                style: AdminTextStyles.tableHeader(context),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

// ── Table row ─────────────────────────────────────────────────────────────────

class _WallpaperRow extends StatefulWidget {
  final WallpaperEntity wallpaper;
  final bool isLast;
  final bool isSelected;
  final String status;
  final bool isTablet;
  final VoidCallback onTap;

  const _WallpaperRow({
    required this.wallpaper,
    required this.isLast,
    required this.isSelected,
    required this.status,
    required this.isTablet,
    required this.onTap,
  });

  @override
  State<_WallpaperRow> createState() => _WallpaperRowState();
}

class _WallpaperRowState extends State<_WallpaperRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final w = widget.wallpaper;
    final isSelected = widget.isSelected;

    Color rowBg = AdminColors.surface;
    if (isSelected) {
      rowBg = AdminColors.goldBg;
    } else if (_hovered) {
      rowBg = AdminColors.rowHover;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: AdminDimensions.tableRowHeight,
          decoration: BoxDecoration(
            color: rowBg,
            border: isSelected
                ? const Border(
                    left: BorderSide(color: AdminColors.gold, width: 3),
                    bottom: BorderSide(color: AdminColors.border),
                  )
                : widget.isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(color: AdminColors.border)),
          ),
          padding: EdgeInsets.only(
            left: isSelected ? 13 : 16, // compensate for 3px border
            right: 16,
          ),
          child: Row(
            children: [
              // Checkbox
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => widget.onTap(),
                  activeColor: AdminColors.gold,
                  checkColor: AdminColors.onGold,
                  side: const BorderSide(color: AdminColors.border),
                ),
              ),
              const SizedBox(width: 12),

              // Thumbnail + name
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AdminDimensions.thumbnailRadius),
                      child: w.thumbnailUrl.isNotEmpty
                          ? Image.network(
                              w.thumbnailUrl,
                              width: AdminDimensions.thumbnailWidth,
                              height: AdminDimensions.thumbnailHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, e, s) =>
                                  _ThumbnailPlaceholder(),
                            )
                          : _ThumbnailPlaceholder(),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w.title,
                            style: AdminTextStyles.tableCell(context)
                                .copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '#${w.id.substring(0, 7).toUpperCase()}',
                            style: AdminTextStyles.bodySmMuted(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Category + Tier (hidden on tablet)
              if (!widget.isTablet) ...[
                SizedBox(
                  width: 100,
                  child: Text(
                    w.category,
                    style: AdminTextStyles.tableCell(context)
                        .copyWith(color: AdminColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Center(
                    child: w.isPremium
                        ? const Icon(Icons.workspace_premium_rounded,
                            color: AdminColors.gold, size: 18)
                        : Text('FREE',
                            style: AdminTextStyles.labelSm(context)
                                .copyWith(color: AdminColors.textSecondary),
                            textAlign: TextAlign.center),
                  ),
                ),
              ],

              // Status badge
              SizedBox(
                width: 100,
                child: Center(
                  child: _StatusBadge(status: widget.status),
                ),
              ),

              // Stats
              SizedBox(
                width: 90,
                child: Text(
                  '${_formatStat(w.downloadCount)} DL',
                  style: AdminTextStyles.tableCell(context)
                      .copyWith(color: AdminColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatStat(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

// ── Grid body ─────────────────────────────────────────────────────────────────

class _GridBody extends StatelessWidget {
  final List<WallpaperEntity> wallpapers;
  final String? selectedId;
  final String Function(WallpaperEntity) wallpaperStatus;
  final ValueChanged<WallpaperEntity?> onSelect;

  const _GridBody({
    required this.wallpapers,
    required this.selectedId,
    required this.wallpaperStatus,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cols = ResponsiveHelper.gridColumns(
      context,
      desktop: 4,
      tablet: 3,
      mobile: 2,
    );
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: wallpapers.length,
      itemBuilder: (ctx, i) {
        final w = wallpapers[i];
        final isSelected = w.id == selectedId;
        return GestureDetector(
          onTap: () => onSelect(w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AdminColors.gold : AdminColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  w.thumbnailUrl.isNotEmpty
                      ? Image.network(w.thumbnailUrl, fit: BoxFit.cover,
                          errorBuilder: (ctx, e, s) =>
                              const ColoredBox(color: AdminColors.inputSurface))
                      : const ColoredBox(color: AdminColors.inputSurface),
                  // Bottom overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xCC000000), Colors.transparent],
                        ),
                      ),
                      child: Text(
                        w.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _StatusBadge(status: wallpaperStatus(w)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Table Footer / Pagination ─────────────────────────────────────────────────

class _TableFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalItems;
  final ValueChanged<int> onPageChange;

  const _TableFooter({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalItems,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {


    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            totalItems == 0
                ? 'No results'
                : 'Page ${currentPage + 1} of ${totalPages == 0 ? 1 : totalPages}',
            style: AdminTextStyles.bodySmMuted(context),
          ),
          const Spacer(),
          // Prev
          _PaginationBtn(
            icon: Icons.chevron_left,
            enabled: currentPage > 0,
            onTap: () => onPageChange(currentPage - 1),
          ),
          const SizedBox(width: 4),
          // Next
          _PaginationBtn(
            icon: Icons.chevron_right,
            enabled: currentPage < totalPages - 1,
            onTap: () => onPageChange(currentPage + 1),
          ),
        ],
      ),
    );
  }
}

class _PaginationBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _PaginationBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AdminColors.inputSurface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AdminColors.border),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AdminColors.textPrimary : AdminColors.textTertiary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Side Panel (Right — Wallpaper Preview + Actions)
// ─────────────────────────────────────────────────────────────────────────────

class _SidePanel extends StatefulWidget {
  final WallpaperEntity wallpaper;
  final String Function(WallpaperEntity) wallpaperStatus;
  final Future<void> Function(String id, String status) onSetStatus;
  final Future<void> Function(String id, bool value) onToggleFeature;
  final Future<void> Function(String id) onDelete;
  final String? deletingId;
  final VoidCallback? onClose;
  final ScrollController? scrollController;

  const _SidePanel({
    required this.wallpaper,
    required this.wallpaperStatus,
    required this.onSetStatus,
    required this.onToggleFeature,
    required this.onDelete,
    this.deletingId,
    this.onClose,
    this.scrollController,
  });

  @override
  State<_SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<_SidePanel> {
  String? _statusDropValue;

  @override
  void didUpdateWidget(_SidePanel old) {
    super.didUpdateWidget(old);
    if (old.wallpaper.id != widget.wallpaper.id) {
      _statusDropValue = null;
    }
  }

  String get _currentStatus =>
      _statusDropValue ?? widget.wallpaperStatus(widget.wallpaper);

  @override
  Widget build(BuildContext context) {
    final w = widget.wallpaper;
    final fileSizeMb = (w.width * w.height * 4 / (1024 * 1024)).toStringAsFixed(1);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text(
              'Wallpaper Details',
              style: AdminTextStyles.headlineSm(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (widget.onClose != null)
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: widget.onClose,
                color: AdminColors.textSecondary,
                hoverColor: AdminColors.rowHover,
                splashRadius: 20,
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Preview image
        Stack(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AdminColors.inputSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AdminColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: w.imageUrl.isNotEmpty
                  ? Image.network(
                      w.imageUrl,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, e, s) => const Center(
                        child: Icon(Icons.image_outlined,
                            size: 40, color: AdminColors.textTertiary),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image_outlined,
                          size: 40, color: AdminColors.textTertiary),
                    ),
            ),
            if (w.isPremium)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AdminColors.premiumBg,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AdminColors.premium, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.workspace_premium_rounded,
                          color: AdminColors.premium, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'PREMIUM',
                        style: AdminTextStyles.labelSm(context).copyWith(
                          color: AdminColors.premium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 8,
              right: 8,
              child: _StatusBadge(status: _currentStatus),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Title + ID
        Text(
          w.title,
          style: AdminTextStyles.headlineSm(context).copyWith(
            fontWeight: FontWeight.bold,
            color: AdminColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.person_outline_rounded,
                size: 14, color: AdminColors.textSecondary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'by ${w.uploadedBy.isNotEmpty ? w.uploadedBy : 'System'}',
                style: AdminTextStyles.bodySmMuted(context),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AdminColors.inputSurface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AdminColors.border),
              ),
              child: Text(
                '#${w.id.substring(0, 7).toUpperCase()}',
                style: AdminTextStyles.labelSm(context).copyWith(
                  color: AdminColors.textSecondary,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        const _SectionHeader(title: 'QUICK ACTIONS'),
        const SizedBox(height: 10),

        // Edit + Feature
        Row(
          children: [
            Expanded(
              child: AdminButton.secondary(
                label: 'Edit',
                icon: Icons.edit_outlined,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AdminButton.primary(
                label: w.isEditorChoice ? 'Featured' : 'Feature',
                icon: w.isEditorChoice
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                onTap: () =>
                    widget.onToggleFeature(w.id, !w.isEditorChoice),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Status dropdown
        _StatusDropdown(
          currentStatus: _currentStatus,
          onChanged: (s) async {
            setState(() => _statusDropValue = s);
            await widget.onSetStatus(w.id, s);
          },
        ),
        const SizedBox(height: 8),

        // Delete
        SizedBox(
          width: double.infinity,
          child: AdminButton.danger(
            label: widget.deletingId == w.id ? 'Deleting…' : 'Delete Wallpaper',
            icon: Icons.delete_outline,
            isLoading: widget.deletingId == w.id,
            onTap: () => _confirmDelete(context, w.id),
          ),
        ),

        const SizedBox(height: 24),
        const _SectionHeader(title: 'PROPERTIES'),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: AdminColors.inputSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AdminColors.border),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _PropertyRow(
                label: 'Resolution',
                value: w.resolution.isNotEmpty ? w.resolution : '${w.width}×${w.height}',
                icon: Icons.aspect_ratio_rounded,
              ),
              const Divider(color: AdminColors.border, height: 16),
              _PropertyRow(
                label: 'File Size',
                value: '$fileSizeMb MB',
                icon: Icons.sd_storage_rounded,
              ),
              const Divider(color: AdminColors.border, height: 16),
              _PropertyRow(
                label: 'Format',
                value: 'WEBP',
                icon: Icons.insert_drive_file_rounded,
              ),
              const Divider(color: AdminColors.border, height: 16),
              _PropertyRow(
                label: 'Upload Date',
                value: _formatDate(w.createdAt),
                icon: Icons.calendar_today_rounded,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const _SectionHeader(title: 'TAGS & SEO'),
        const SizedBox(height: 10),

        Text('URL Slug', style: AdminTextStyles.bodySmMuted(context)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AdminColors.inputSurface,
            borderRadius:
                BorderRadius.circular(AdminDimensions.inputRadius),
            border: Border.all(color: AdminColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.link_rounded, size: 14, color: AdminColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _toSlug(w.title),
                  style: AdminTextStyles.bodyMd(context)
                      .copyWith(color: AdminColors.textSecondary, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text('Tag Cloud', style: AdminTextStyles.bodySmMuted(context)),
        const SizedBox(height: 8),
        if (w.tags.isEmpty)
          Text('No tags', style: AdminTextStyles.bodySmMuted(context))
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: w.tags
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AdminColors.inputSurface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AdminColors.border),
                      ),
                      child: Text(
                        t,
                        style: AdminTextStyles.labelSm(context).copyWith(
                          color: AdminColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
      ],
    );

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      child: content,
    );
  }

  void _confirmDelete(BuildContext ctx, String id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AdminColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminDimensions.dialogRadius),
          side: const BorderSide(color: AdminColors.border),
        ),
        title: Text('Delete Wallpaper',
            style: AdminTextStyles.headlineSm(ctx)),
        content: Text(
          'Delete "${widget.wallpaper.title}"? This cannot be undone.',
          style: AdminTextStyles.bodyMdMuted(ctx),
        ),
        actions: [
          AdminButton.secondary(
              label: 'Cancel',
              onTap: () => Navigator.pop(ctx)),
          AdminButton.danger(
            label: 'Delete',
            onTap: () {
              Navigator.pop(ctx);
              widget.onDelete(id);
            },
          ),
        ],
      ),
    );
  }

  String _toSlug(String title) =>
      title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

// ── Status Dropdown in side panel ─────────────────────────────────────────────

class _StatusDropdown extends StatelessWidget {
  final String currentStatus;
  final ValueChanged<String> onChanged;
  const _StatusDropdown({required this.currentStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminDimensions.buttonHeightMd,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AdminColors.inputSurface,
        borderRadius: BorderRadius.circular(AdminDimensions.inputRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentStatus,
          isExpanded: true,
          dropdownColor: AdminColors.surface,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AdminColors.textSecondary, size: 18),
          style: AdminTextStyles.bodyMd(context),
          items: ['Published', 'Rejected'].map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(
                'Status: $s',
                style: AdminTextStyles.bodyMd(context)
                    .copyWith(color: AdminColors.textPrimary),
              ),
            );
          }).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AdminTextStyles.tableHeader(context).copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: AdminColors.gold.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Divider(color: AdminColors.border, height: 1),
        ),
      ],
    );
  }
}

// ── Property Row ──────────────────────────────────────────────────────────────

class _PropertyRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _PropertyRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: AdminTextStyles.bodySmMuted(context)),
          ),
          Text(value,
              style: AdminTextStyles.bodySm(context)
                  .copyWith(color: AdminColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Badge
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    BadgeType type;
    switch (status.toLowerCase()) {
      case 'published':
        type = BadgeType.success;
        break;
      case 'pending':
        type = BadgeType.warning;
        break;
      case 'rejected':
        type = BadgeType.error;
        break;
      default:
        type = BadgeType.inactive;
    }
    return AdminBadge(label: status, type: type);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _ThumbnailPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AdminDimensions.thumbnailWidth,
      height: AdminDimensions.thumbnailHeight,
      color: AdminColors.inputSurface,
      child: const Icon(Icons.image_outlined,
          size: 18, color: AdminColors.textTertiary),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.image_outlined,
              size: 48, color: AdminColors.textTertiary),
          SizedBox(height: AdminDimensions.md),
          Text('No wallpapers found',
              style: AdminTextStyles.headlineSm(context)),
          const SizedBox(height: 4),
          Text('Try adjusting your filters',
              style: AdminTextStyles.bodySmMuted(context)),
        ],
      ),
    );
  }
}
