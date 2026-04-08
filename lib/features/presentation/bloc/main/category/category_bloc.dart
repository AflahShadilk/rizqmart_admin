import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/entities/main/category_model.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/category/add_category_usecases.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/category/add_variant_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/category/delete_category_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/category/delete_variant_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/category/get_category_usecases.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/category/update_category_usecase.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/category/category_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/category/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryUsecases getCategoryUsecases;
  final AddCategoryUsecases addCategoryUsecases;
  final AddVariantUsecase addVariantUsecase;
  final UpdateCategoryUsecase updateCategoryUsecase;
  final DeleteCategoryUsecase deleteCategoryUsecase;
  final DeleteVariantUsecase deleteVariantusecase;
  StreamSubscription<List<CategoryModel>>? _categoriesSubscription;

  CategoryBloc({required this.getCategoryUsecases, required this.addCategoryUsecases, required this.addVariantUsecase, required this.updateCategoryUsecase, required this.deleteCategoryUsecase, required this.deleteVariantusecase})
      : super(CategoryLoadingState()) {
    on<LoadingCategoryEvent>(_onLoadingCategories);
    on<CategoryLoadedEvent>(_onCategoriesLoaded);
    on<AddCategoryEvent>(_onAddCategory);
    on<AddVariantEvent>(_onAddVariant);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteVariantEvent>(_onDeleteVariant);
    on<DeleteCategoryEvent>(_onCategoryDelete);

    add(LoadingCategoryEvent());
  }

  void _onLoadingCategories(LoadingCategoryEvent event, Emitter<CategoryState> emit) {
    emit(CategoryLoadingState());
    _categoriesSubscription?.cancel();
    _categoriesSubscription = getCategoryUsecases().listen((categories) {
      add(CategoryLoadedEvent(categories));
    });
  }

  void _onCategoriesLoaded(CategoryLoadedEvent event, Emitter<CategoryState> emit) {
    emit(CategoryLoadedState(event.categories));
  }

  void _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) async {
    final result = await addCategoryUsecases(event.category);
    result.fold(
      (failure) => emit(CategoryFailureState(failure.message)),
      (_) => emit(CategorySuccessState("Category added successfully")),
    );
  }

  Future<void> _onAddVariant(AddVariantEvent event, Emitter<CategoryState> emit) async {
    final result = await addVariantUsecase(event.categoryId, event.variant);
    result.fold(
      (failure) => emit(CategoryFailureState(failure.message)),
      (_) {
        add(LoadingCategoryEvent());
        emit(CategorySuccessState('Variant added successfully'));
      },
    );
  }

  Future<void> _onUpdateCategory(UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    final result = await updateCategoryUsecase(event.model);
    result.fold(
      (failure) => emit(CategoryFailureState(failure.message)),
      (_) => emit(CategorySuccessState('Category updated successfully')),
    );
  }

  Future<void> _onDeleteVariant(DeleteVariantEvent event, Emitter<CategoryState> emit) async {
    final result = await deleteVariantusecase(event.categoryId, event.variant);
    result.fold(
      (failure) => emit(CategoryFailureState(failure.message)),
      (_) => add(LoadingCategoryEvent()),
    );
  }

  Future<void> _onCategoryDelete(DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    add(LoadingCategoryEvent());
    final result = await deleteCategoryUsecase(event.id);
    result.fold(
      (failure) => emit(CategoryFailureState(failure.message)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    return super.close();
  }
}
