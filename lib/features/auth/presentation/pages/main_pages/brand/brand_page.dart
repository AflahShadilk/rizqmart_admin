import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/brand/page/brand_page_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/brand/page/brand_page_cubit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/add_brand_form_web.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/widgets/brand_grid_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/widgets/brand_list_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/delete_config.dart';
import 'package:rizqmartadmin/widgets/grid_list_toggle.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/brand/brand_layout_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/brand/brand_layout_state.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => BrandPageState();
}

class BrandPageState extends State<BrandPage> {
  final TextEditingController searchController = TextEditingController();
  late BrandPageCubit pageCubit;
  late BrandLayoutCubit layoutCubit;

  @override
  void initState() {
    super.initState();
    pageCubit = BrandPageCubit();
    layoutCubit = BrandLayoutCubit();
  }

  @override
  void dispose() {
    searchController.dispose();
    pageCubit.close();
    layoutCubit.close();
    super.dispose();
  }

  List<dynamic> filterBrands(List<dynamic> brands, String query) {
    if (query.isEmpty) return brands;
    return brands.where((brand) {
      final brandName = brand.name?.toLowerCase() ?? '';
      return brandName.contains(query.toLowerCase());
    }).toList();
  }

  void _showAddBrandDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<BrandBloc>(context),
        child: const AddBrandFormWeb(),
      ),
    );
  }

  void _showEditBrandDialog(BuildContext context, BrandEntity brand) {
    final brandState = BlocProvider.of<BrandBloc>(context).state;
    final brandList = brandState is BrandLoadedState
        ? (brandState).brand.cast<BrandEntity>()
        : <BrandEntity>[];
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<BrandBloc>(context),
        child: AddBrandFormWeb(brands: brand, brandslist: brandList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: pageCubit),
        BlocProvider.value(value: layoutCubit),
      ],
      child: BlocConsumer<BrandBloc, BrandState>(
        listener: (context, state) {
          if (state is BrandLoadingSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.matGreen,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is BrandFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.matRed,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<BrandLayoutCubit, BrandLayoutState>(
            builder: (context, layoutState) {
              final isGridView = layoutState.isGridView;
              return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: BlocBuilder<BrandPageCubit, BrandPageCubitState>(
              builder: (context, pageState) {
                if (state is BrandLoadingState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                        16.h,
                        Text(
                          'Loading brands...',
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is BrandLoadedState) {
                  final allBrands = state.brand;

                  if (allBrands.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.indigo.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.branding_watermark_rounded,
                              size: 64,
                              color: AppColors.indigo,
                            ),
                          ),
                          24.h,
                          Text(
                            'No brands yet',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.bodyLarge?.color,
                              fontFamily: 'Inter',
                            ),
                          ),
                          8.h,
                          Text(
                            'Start by adding your first brand.',
                            style: TextStyle(
                              fontSize: 15,
                              color: theme.textTheme.bodySmall?.color,
                              fontFamily: 'Inter',
                            ),
                          ),
                          24.h,
                          _buildAddButton(context),
                        ],
                      ),
                    );
                  }

                  final displayBrands =
                      filterBrands(allBrands, pageState.searchQuery);

                  return Column(
                    children: [
                      // ---------------- Modern Header Card ----------------
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        margin: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
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
                                color: AppColors.indigo.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.branding_watermark_rounded,
                                color: AppColors.indigo,
                                size: 28,
                              ),
                            );

                            final titleColumn = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Brands',
                                  style: TextStyle(
                                    fontSize: isCompact ? 20 : 24,
                                    fontWeight: FontWeight.w700,
                                    color: theme.textTheme.bodyLarge?.color,
                                    letterSpacing: -0.5,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                4.h,
                                Text(
                                  '${allBrands.length} ${allBrands.length == 1 ? 'brand' : 'brands'} available',
                                  style: TextStyle(
                                    fontSize: isCompact ? 12 : 14,
                                    color: theme.textTheme.bodySmall?.color,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            );

                            final toggleButtons = GridListToggle(
                              isGridView: isGridView,
                              onToggle: (isGrid) {
                                layoutCubit.toggleView(isGrid);
                              },
                            );

                            final addButton = _buildAddButton(context);

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

                      // ---------------- Search Bar Section ----------------
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: isDark ? 0.1 : 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              pageCubit.updateSearchQuery(value);
                            },
                            style: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                              fontFamily: 'Inter',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search brands...',
                              hintStyle: TextStyle(
                                color: theme.hintColor,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: theme.hintColor,
                                size: 22,
                              ),
                              suffixIcon: pageState.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: theme.hintColor,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        searchController.clear();
                                        pageCubit.clearSearch();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      16.h,

                      // ---------------- Main Content Area ----------------
                      Expanded(
                        child: displayBrands.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 64,
                                      color: theme
                                          .textTheme.bodySmall?.color,
                                    ),
                                    16.h,
                                    Text(
                                      'No brands match "${pageState.searchQuery}"',
                                      style: TextStyle(
                                        color: theme.textTheme.bodySmall?.color,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  if (!isGridView) {
                                    // ---------------- List View ----------------
                                    return ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      itemCount: displayBrands.length,
                                      separatorBuilder:
                                          (context, index) => 12.h,
                                      itemBuilder: (context, index) {
                                        final brand = displayBrands[index] as BrandEntity;
                                        return Center(
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(maxWidth: 900),
                                            child: BrandListCard(
                                              brand: brand,
                                              onEdit: () => _showEditBrandDialog(context, brand),
                                              onDelete: () => handleDelete(context, brand),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  // ---------------- Grid View ----------------
                                  int crossAxisCount = 1;
                                  if (constraints.maxWidth > 1400) {
                                    crossAxisCount = 6;
                                  } else if (constraints.maxWidth > 1100) {
                                    crossAxisCount = 5;
                                  } else if (constraints.maxWidth > 800) {
                                    crossAxisCount = 4;
                                  } else if (constraints.maxWidth > 550) {
                                    crossAxisCount = 2;
                                  }

                                  return GridView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: crossAxisCount == 1 ? 12 : 20,
                                      mainAxisSpacing: crossAxisCount == 1 ? 12 : 20,
                                      childAspectRatio: crossAxisCount == 1 ? 1.2 : 0.72,
                                    ),
                                    itemCount: displayBrands.length,
                                    itemBuilder: (context, index) {
                                      final brand =
                                          displayBrands[index]
                                              as BrandEntity;
                                      return BrandGridCard(
                                        brand: brand,
                                        onEdit: () =>
                                            _showEditBrandDialog(
                                                context, brand),
                                        onDelete: () =>
                                            handleDelete(
                                                context, brand),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                } else if (state is BrandFailureState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.matRed.withValues(alpha: 0.8),
                        ),
                        20.h,
                        Text(
                          'Failed to load brands',
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        8.h,
                        Text(
                          state.error,
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          );
            },
          );
        },
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showAddBrandDialog(context),
      icon: const Icon(Icons.add_rounded, size: 22, color: AppColors.white),
      label: Text(
        'Add Brand',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          fontFamily: 'Inter',
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.addButtonColor,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}