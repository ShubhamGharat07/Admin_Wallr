// lib/core/widgets/admin_table.dart

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../constants/admin_colors.dart';
import '../constants/admin_dimensions.dart';
import '../constants/admin_text_styles.dart';
import 'loading_widget.dart';

class AdminTable extends StatelessWidget {
  final List<DataColumn2> columns;
  final List<DataRow2> rows;
  final bool isLoading;
  final String emptyMessage;
  final Widget? bottomWidget;

  const AdminTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage = 'No data found',
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const SizedBox(height: 300, child: LoadingWidget());

    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminDimensions.cardRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: Column(
        children: [
          DataTable2(
            columns: columns,
            rows: rows,
            headingRowColor: WidgetStateProperty.all(AdminColors.tableHeader),
            headingRowHeight: AdminDimensions.tableHeaderHeight,
            dataRowHeight: AdminDimensions.tableRowHeight,
            dividerThickness: 1,
            border: TableBorder(
              horizontalInside: BorderSide(
                color: AdminColors.divider,
                width: 1,
              ),
            ),
            headingTextStyle: AdminTextStyles.tableHeader(context),
            dataTextStyle: AdminTextStyles.tableCell(context),
            empty: Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Text(
                  emptyMessage,
                  style: AdminTextStyles.bodyMdMuted(context),
                ),
              ),
            ),
            columnSpacing: 16,
            horizontalMargin: 16,
            minWidth: 600,
          ),
          if (bottomWidget != null) ...[
            Divider(color: AdminColors.divider, height: 1),
            bottomWidget!,
          ],
        ],
      ),
    );
  }
}
