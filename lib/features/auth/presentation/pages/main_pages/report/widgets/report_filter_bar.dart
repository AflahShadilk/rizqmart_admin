import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/report/report_state.dart';

class ReportFilterBar extends StatelessWidget {
  final ReportState dateState;
  final Function(SalesFilter) onFilterChanged;
  final VoidCallback onCustomDateSelected;

  const ReportFilterBar({
    super.key,
    required this.dateState,
    required this.onFilterChanged,
    required this.onCustomDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildFilterChip(context, 'Today', SalesFilter.today),
        _buildFilterChip(context, 'Week', SalesFilter.thisWeek),
        _buildFilterChip(context, 'Month', SalesFilter.thisMonth),
        TextButton.icon(
          onPressed: onCustomDateSelected,
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(
            '${DateFormat('dd MMM').format(dateState.startDate)} – ${DateFormat('dd MMM').format(dateState.endDate)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: dateState.selectedFilter == SalesFilter.custom
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: dateState.selectedFilter == SalesFilter.custom
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, SalesFilter filter) {
    final isSelected = dateState.selectedFilter == filter;
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onPressed: () => onFilterChanged(filter),
    );
  }
}
