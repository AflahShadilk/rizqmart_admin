import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/unit/search/unit_search_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/units/unit_adding_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/units/widgets/unit_delete_config.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';
import 'package:rizqmartadmin/widgets/global_add_button.dart';
import 'package:rizqmartadmin/widgets/grid_list_toggle.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/unit/search/unit_search_state.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});

  @override
  State<UnitsPage> createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  final TextEditingController _searchController = TextEditingController();

  List<UnitsEntity> filterVariant(List<UnitsEntity> units, String query) {
    if (query.isEmpty) return units;
    return units
        .where(
            (unit) => unit.unitName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadingCategoryEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddUnitDialog(BuildContext context, List<UnitsEntity> allUnits) {
    UnitDialog.show(context, allUnits: allUnits);
  }

  void _showEditUnitDialog(BuildContext context, List<UnitsEntity> allUnits, UnitsEntity unit) {
    UnitDialog.show(context, allUnits: allUnits, unit: unit);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => UnitsSearchCubit(),
      child: BlocConsumer<UnitBloc, UnitState>(
        listener: (context, state) {
          if (state is UnitSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.matGreen,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is UnitFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.matRed,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Builder(builder: (context) {
              if (state is UnitLoadingState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                      16.h,
                      Text(
                        'Loading units...',
                        style: GoogleFonts.inter(
                          color: theme.textTheme.bodySmall?.color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is UnitLoadedState) {
                final allUnits = state.unit;

                if (allUnits.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.straighten_rounded,
                            size: 64,
                            color: AppColors.purple,
                          ),
                        ),
                        24.h,
                        Text(
                          'No units yet',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        8.h,
                        Text(
                          'Start by adding your first unit variant.',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        24.h,
                        _buildAddButton(context, allUnits),
                      ],
                    ),
                  );
                }

                return BlocBuilder<UnitsSearchCubit, UnitSearchState>(
                  builder: (context, searchState) {
                    final display = filterVariant(allUnits, searchState.searchQuery);
                    final isGridView = searchState.isGridView;

                    return Column(
                      children: [
                        // Modern Header Card
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          margin: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black
                                    .withValues(alpha: isDark ? 0.2 : 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: LayoutBuilder(
                            builder: (context, headerConstraints) {
                              final isCompact =
                                  headerConstraints.maxWidth < 600;

                              final icon = Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.purple
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.straighten_rounded,
                                  color: AppColors.purple,
                                  size: 28,
                                ),
                              );

                              final titleColumn = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Units & Variants',
                                    style: GoogleFonts.inter(
                                      fontSize: isCompact ? 20 : 24,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          theme.textTheme.bodyLarge?.color,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  4.h,
                                  Text(
                                    '${allUnits.length} ${allUnits.length == 1 ? 'unit' : 'units'} available',
                                    style: GoogleFonts.inter(
                                      fontSize: isCompact ? 12 : 14,
                                      color:
                                          theme.textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              );

                              final toggleButtons = GridListToggle(
                                isGridView: isGridView,
                                onToggle: (isGrid) {
                                  context.read<UnitsSearchCubit>().toggleView(isGrid);
                                },
                              );

                              final addButton =
                                  _buildAddButton(context, allUnits);

                              if (isCompact) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        icon,
                                        16.w,
                                        Expanded(child: titleColumn),
                                      ],
                                    ),
                                    16.h,
                                    Row(
                                      children: [
                                        toggleButtons,
                                        const Spacer(),
                                        addButton,
                                      ],
                                    ),
                                  ],
                                );
                              }

                              return Row(
                                children: [
                                  icon,
                                  20.w,
                                  Expanded(child: titleColumn),
                                  toggleButtons,
                                  16.w,
                                  addButton,
                                ],
                              );
                            },
                          ),
                        ),

                        // Search Bar
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: 0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(
                                      alpha: isDark ? 0.1 : 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                context
                                    .read<UnitsSearchCubit>()
                                    .updateSearch(value);
                              },
                              style: GoogleFonts.inter(
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search units...',
                                hintStyle: GoogleFonts.inter(
                                  color: theme.hintColor,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: theme.hintColor,
                                  size: 22,
                                ),
                                suffixIcon: searchState.searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.close_rounded,
                                          color: theme.hintColor,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          context
                                              .read<UnitsSearchCubit>()
                                              .clearSearch();
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        16.h,

                        // Content Area
                        Expanded(
                          child: display.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 64,
                                        color:
                                            theme.textTheme.bodySmall?.color,
                                      ),
                                      16.h,
                                      Text(
                                        'No units match "${searchState.searchQuery}"',
                                        style: GoogleFonts.inter(
                                          color: theme
                                              .textTheme.bodySmall?.color,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : LayoutBuilder(
                                  builder: (context, constraints) {
                                    if (!isGridView) {
                                      return ListView.separated(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 16,
                                        ),
                                        itemCount: display.length,
                                        separatorBuilder:
                                            (context, index) => 12.h,
                                        itemBuilder: (context, index) {
                                          final unit = display[index];
                                          return UnitListCard(
                                            unit: unit,
                                            onEdit: () =>
                                                _showEditUnitDialog(
                                                    context,
                                                    allUnits,
                                                    unit),
                                            onDelete: () =>
                                                handleDeleteUnit(
                                                    context, unit),
                                          );
                                        },
                                      );
                                    }

                                    // Grid View
                                    int crossAxisCount = 1;
                                    if (constraints.maxWidth > 1400) {
                                      crossAxisCount = 6;
                                    } else if (constraints.maxWidth >
                                        1100) {
                                      crossAxisCount = 5;
                                    } else if (constraints.maxWidth >
                                        800) {
                                      crossAxisCount = 4;
                                    } else if (constraints.maxWidth >
                                        550) {
                                      crossAxisCount = 2;
                                    }

                                    return GridView.builder(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing:
                                            crossAxisCount == 1
                                                ? 12
                                                : 20,
                                        mainAxisSpacing:
                                            crossAxisCount == 1
                                                ? 12
                                                : 20,
                                        childAspectRatio:
                                            crossAxisCount == 1
                                                ? 2.5
                                                : 1.0,
                                      ),
                                      itemCount: display.length,
                                      itemBuilder: (context, index) {
                                        final unit = display[index];
                                        return UnitGridCard(
                                          unit: unit,
                                          onEdit: () =>
                                              _showEditUnitDialog(
                                                  context,
                                                  allUnits,
                                                  unit),
                                          onDelete: () =>
                                              handleDeleteUnit(
                                                  context, unit),
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            }),
          );
        },
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, List<UnitsEntity> allUnits) {
    return GlobalAddButton(
      label: 'Add Unit',
      onPressed: () => _showAddUnitDialog(context, allUnits),
    );
  }
}

// ─── Grid Card ───────────────────────────────────────────────────────────────
class UnitGridCard extends StatelessWidget {
  final UnitsEntity unit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UnitGridCard({
    super.key,
    required this.unit,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedHoverCard(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.straighten_rounded,
                      color: AppColors.purple,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  _actionButton(
                    icon: Icons.edit_rounded,
                    color: AppColors.chartBlue,
                    onTap: onEdit,
                    tooltip: 'Edit',
                  ),
                  6.w,
                  _actionButton(
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.chartRed,
                    onTap: onDelete,
                    tooltip: 'Delete',
                  ),
                ],
              ),
              const Spacer(),
              Text(
                unit.unitName,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              6.h,
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      unit.unitType,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald,
                      ),
                    ),
                  ),
                  8.w,
                  Flexible(
                    child: Text(
                      '${unit.wieght}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
      );
    
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 15),
        onPressed: onTap,
        tooltip: tooltip,
      ),
    );
  }
}

// ─── List Card ───────────────────────────────────────────────────────────────
class UnitListCard extends StatelessWidget {
  final UnitsEntity unit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UnitListCard({
    super.key,
    required this.unit,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedHoverCard(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.straighten_rounded,
                  color: AppColors.purple,
                  size: 24,
                ),
              ),
              16.w,
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.unitName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            unit.unitType,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.emerald,
                            ),
                          ),
                        ),
                        8.w,
                        Text(
                          '${unit.wieght}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.chartBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit_rounded,
                      color: AppColors.chartBlue, size: 16),
                  onPressed: onEdit,
                  tooltip: 'Edit Unit',
                ),
              ),
              8.w,
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.chartRed.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.chartRed, size: 16),
                  onPressed: onDelete,
                  tooltip: 'Delete Unit',
                ),
              ),
            ],
          ),
      );
  }
}