// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/units/display_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/units/unit_adding_page.dart';

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
  Widget build(BuildContext context) {
    return BlocConsumer<UnitBloc, UnitState>(
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
                      _buildAddButtonUnits(context, allUnits),
                    ],
                  ),
                );
              }
              final display = filterVariant(allUnits, _searchController.text);
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
                        _buildAddButtonUnits(context, allUnits),
                      ],
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) {
                        setState(() {});
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
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.charcoal,
                                  size: 24,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
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

                  // Units List
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
                                  'No Units match "${_searchController.text}"',
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
                                    _handleDelete(context, unit);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        );
      },
    );
  }

  void _handleDelete(BuildContext context, UnitsEntity unit) {
    try {
      final productBloc = context.read<ProductBloc>();

      final productState = productBloc.state;

      List<dynamic> products = [];

      if (productState is LoadingProductState) {
        productBloc.add(LoadingProductEvent());
        return;
      }

      if (productState is LoadedProductState) {
        products = productState.product ?? [];
      } else {
        products = [];
      }

      bool isUsed = false;

      if (products.isNotEmpty) {
        isUsed = products.whereType<AddProductEntity>().any((product) {
          // ignore: unrelated_type_equality_checks
          bool matches = product.variant == unit.id;
          return matches;
        });
      }

      if (isUsed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Cannot delete! This unit is used in products.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        _showDeleteConfirmDialog(context, unit);
      }
    } catch (e) {
      _showDeleteConfirmDialog(context, unit);
    }
  }

  void _showDeleteConfirmDialog(BuildContext context, UnitsEntity unit) {
    final unitsBloc = context.read<UnitBloc>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              Text(
                'Delete Unit',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${unit.unitName}"? This action cannot be undone.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                unitsBloc.add(UnitDeletingEvent(unit.id));
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unit deleted successfully'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddButtonUnits(BuildContext context, List<UnitsEntity> units) {
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
                  existingUnits: units,
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
