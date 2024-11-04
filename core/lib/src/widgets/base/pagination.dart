// lib/core/widgets/base/pagination.dart
import 'package:flutter/material.dart';

import 'per_page.dart';

class BasePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final Function(int) onPageChanged;
  final Function(int?) onRowsPerPageChanged;
  final List<int> availableRowsPerPage;

  const BasePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
    required this.onRowsPerPageChanged,
    this.availableRowsPerPage = const [5, 10, 20, 30, 50],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            PerPage(
                itemsPerPage: itemsPerPage,
                availableRowsPerPage: availableRowsPerPage,
                onRowsPerPageChanged: onRowsPerPageChanged),
          ],
        ),
        Row(
          children: [
            Text(
              '${(currentPage - 1) * itemsPerPage + 1}-${currentPage * itemsPerPage} of $totalItems',
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed:
                  currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: currentPage < totalPages
                  ? () => onPageChanged(currentPage + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
