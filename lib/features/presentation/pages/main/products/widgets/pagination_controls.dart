import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';

/// A reusable pagination controls widget.
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(int) onPageSelected;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ---------------- Previous Button ----------------
          _PaginationButton(
            icon: Icons.chevron_left,
            label: isDesktop ? 'Prev' : null,
            onPressed: currentPage > 1 ? onPrevious : null,
            theme: theme,
          ),
          
          const SizedBox(width: 16),
          
          // ---------------- Page Numbers ----------------
          if (isDesktop) ..._buildDesktopPageNumbers(theme)
          else ..._buildMobilePageIndicator(theme),
          
          const SizedBox(width: 16),
          
          // ---------------- Next Button ----------------
          _PaginationButton(
            icon: Icons.chevron_right,
            label: isDesktop ? 'Next' : null,
            isNext: true,
            onPressed: currentPage < totalPages ? onNext : null,
            theme: theme,
          ),
        ],
      ),
    );
  }

  // Desktop shows individual page numbers with ellipsis for large ranges
  List<Widget> _buildDesktopPageNumbers(ThemeData theme) {
    List<Widget> pageButtons = [];
    int maxVisiblePages = 5;

    int startPage = 1;
    int endPage = totalPages;

    if (totalPages > maxVisiblePages) {
      if (currentPage <= 3) {
        endPage = maxVisiblePages;
      } else if (currentPage >= totalPages - 2) {
        startPage = totalPages - maxVisiblePages + 1;
      } else {
        startPage = currentPage - 2;
        endPage = currentPage + 2;
      }
    }

    if (startPage > 1) {
      pageButtons.add(_PageNumberButton(
        page: 1,
        isSelected: currentPage == 1,
        onPressed: () => onPageSelected(1),
        theme: theme,
      ));
      if (startPage > 2) {
        pageButtons.add(_EllipsisIndicator(theme: theme));
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_PageNumberButton(
        page: i,
        isSelected: currentPage == i,
        onPressed: () => onPageSelected(i),
        theme: theme,
      ));
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageButtons.add(_EllipsisIndicator(theme: theme));
      }
      pageButtons.add(_PageNumberButton(
        page: totalPages,
        isSelected: currentPage == totalPages,
        onPressed: () => onPageSelected(totalPages),
        theme: theme,
      ));
    }

    return pageButtons;
  }

  // Mobile just shows "Page X of Y"
  List<Widget> _buildMobilePageIndicator(ThemeData theme) {
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        ),
        child: Text(
          'Page $currentPage of $totalPages',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    ];
  }
}

class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final bool isNext;
  final ThemeData theme;

  const _PaginationButton({
    required this.icon,
    this.label,
    required this.onPressed,
    this.isNext = false,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final color = isDisabled ? AppColors.grey400 : theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: label != null ? 16 : 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDisabled 
                  ? theme.dividerColor.withValues(alpha: 0.1) 
                  : theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
            color: isDisabled 
                ? theme.colorScheme.surface.withValues(alpha: 0.5) 
                : theme.colorScheme.primary.withValues(alpha: 0.05),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isNext) Icon(icon, size: 20, color: color),
              if (label != null) ...[
                if (!isNext) const SizedBox(width: 6),
                Text(
                  label!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: color,
                  ),
                ),
                if (isNext) const SizedBox(width: 6),
              ],
              if (isNext) Icon(icon, size: 20, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onPressed;
  final ThemeData theme;

  const _PageNumberButton({
    required this.page,
    required this.isSelected,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: isSelected ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minWidth: 40),
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected 
                    ? theme.colorScheme.primary 
                    : theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              page.toString(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
                color: isSelected ? AppColors.white : theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EllipsisIndicator extends StatelessWidget {
  final ThemeData theme;
  const _EllipsisIndicator({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '...',
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
