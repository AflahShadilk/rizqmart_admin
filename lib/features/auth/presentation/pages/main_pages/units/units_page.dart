// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/unit/search/unit_search_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/units/display_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/units/unit_adding_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/units/widgets/unit_delete_config.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnitsSearchCubit(),
      child: BlocConsumer<UnitBloc, UnitState>(
        listener: (context, state) {
          if (state is UnitSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is UnitFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Units',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackHeading,
                ),
              ),
              elevation: 0,
              backgroundColor: AppColors.backgroundColor,
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Builder(builder: (context) {
              if (state is UnitLoadingState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading units...',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
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
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No units found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        BuildAddButtonUnits(allUnits: allUnits),
                      ],
                    ),
                  );
                }
                return BlocBuilder<UnitsSearchCubit, String>(
                  builder: (context, searchQuery) {
                    final display = filterVariant(allUnits, searchQuery);
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gray.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Manage Units',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackHeading,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${allUnits.length} ${allUnits.length == 1 ? 'Unit' : 'Units'} available',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              BuildAddButtonUnits(allUnits: allUnits),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              context.read<UnitsSearchCubit>().updateSearch(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search Units...',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey.shade400,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.charcoal,
                                size: 24,
                              ),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: AppColors.charcoal,
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        context.read<UnitsSearchCubit>().clearSearch();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.blueAccent,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: display.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No Units match "$searchQuery"',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  itemCount: display.length,
                                  itemBuilder: (context, index) {
                                    final unit = display[index];

                                    return UnitCardAnimationWrapper(
                                      delay: index * 50,
                                      child: UnitCard(
                                        unit: unit,
                                        onEdit: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) => MultiBlocProvider(
                                                providers: [
                                                  BlocProvider.value(
                                                    value: BlocProvider.of<UnitBloc>(
                                                        context),
                                                  ),
                                                  BlocProvider.value(
                                                    value:
                                                        BlocProvider.of<CategoryBloc>(
                                                            context),
                                                  ),
                                                ],
                                                child: BlocBuilder<CategoryBloc,
                                                        CategoryState>(
                                                    builder: (context, state) {
                                                  List<String> categories = [];
                                                  String? selectedCatName;
                                                  if (state is CategoryLoadedState) {
                                                    categories = state.cotegories
                                                        .map((cate) => cate.name)
                                                        .toList();
                                                    if (unit.category.isNotEmpty) {
                                                      try {
                                                        final matchingCategory = state
                                                            .cotegories
                                                            .firstWhere((cat) =>
                                                                cat.id ==
                                                                unit.category);
                                                        selectedCatName =
                                                            matchingCategory.name;
                                                      } catch (e) {
                                                        
                                                        selectedCatName = null;
                                                      }
                                                    }
                                                  } else if (state
                                                      is CategoryLoadingState) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (state
                                                      is CategoryFailureState) {
                                                    return AlertDialog(
                                                      title: const Text('Error'),
                                                      content: Text(state.error),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(context),
                                                          child: const Text('Close'),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return UnitDialog(
                                                    existingUnits: allUnits,
                                                    existingUnit: unit,
                                                    categories: categories,
                                                    selectedCategory: selectedCatName,
                                                  );
                                                })),
                                          );
                                        },
                                        onDelete: () {
                                          handleDeleteUnit(context, unit);
                                        },
                                      ),
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
}

class BuildAddButtonUnits extends StatelessWidget {
  final List<UnitsEntity> allUnits;

  const BuildAddButtonUnits({
    super.key,
    required this.allUnits,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<UnitBloc>(context),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<CategoryBloc>(context),
                ),
              ],
              child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                List<String> categories = [];

                if (state is CategoryLoadedState) {
                  categories = state.cotegories
                      .map((category) => category.name)
                      .toList();
                } else if (state is CategoryLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CategoryFailureState) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text(state.error),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                }
                return UnitDialog(
                  existingUnits: allUnits,
                  categories: categories,
                );
              })),
        );
      },
      icon: const Icon(Icons.add_circle_outline, size: 20),
      label: Text(
        'Add Unit',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        elevation: 2,
        shadowColor: AppColors.green.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}