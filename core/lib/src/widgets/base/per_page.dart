import 'package:flutter/material.dart';

class PerPage extends StatelessWidget {
  final int itemsPerPage;
  final List<int> availableRowsPerPage;
  final ValueChanged<int?> onRowsPerPageChanged;

  const PerPage({
    super.key,
    required this.itemsPerPage,
    required this.availableRowsPerPage,
    required this.onRowsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Rows per page:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 72,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: itemsPerPage,
                items: availableRowsPerPage
                    .map((count) => DropdownMenuItem(
                          value: count,
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: onRowsPerPageChanged,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white70,
                  size: 20,
                ),
                iconSize: 20,
                isExpanded: true,
                borderRadius: BorderRadius.circular(4),
                alignment: AlignmentDirectional.centerStart,
                dropdownColor: Colors.grey[850],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
