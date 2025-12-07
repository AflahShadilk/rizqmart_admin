import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/add_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/delete_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/get_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/update_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUsecase getProductUsecase;
  final AddProductUsecase addProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  StreamSubscription<List<AddProductEntity>>? subscription;
  ProductBloc({required this.getProductUsecase,required this.addProductUsecase,required this.updateProductUsecase,required this.deleteProductUsecase}) : super(LoadingProductState()) {
    on<LoadingProductEvent>(loadingProduct);
    on<LoadedProductEvent>(loadedProduct);
    on<AddingProductEvent>(addingProduct);
    on<UpdatingProductEvent>(updateProduct);
    on<DeletingProductEvent>(deleteProduct);
    add(LoadingProductEvent());
  }

  Future  <void> loadingProduct(
      LoadingProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingProductState());
    subscription?.cancel();
    subscription = getProductUsecase().listen((product) {
      add(LoadedProductEvent(product));
    }, onError: (error) { 
      emit(FailureLoadingState(error.toString()));
    });
  }

  void loadedProduct(LoadedProductEvent event, Emitter<ProductState> emit) {
    emit(LoadedProductState(event.product));
  }

  Future<void> addingProduct(
      AddingProductEvent event, Emitter<ProductState> emit) async {
    try {
      final currentState = state;
      if (currentState is LoadedProductState) {
        final updatedList = List<AddProductEntity>.from(currentState.product)
          ..add(event.product);
        emit(LoadedProductState(updatedList));
      }
      await addProductUsecase(event.product);
      emit(SuccessLoadingState('Created new coupon successfully'));
    } catch (e) {
      add(const LoadingProductEvent());
      emit(FailureLoadingState('Failed to create new coupon:$e'));
    }
  }

  Future<void> updateProduct(
      UpdatingProductEvent event, Emitter<ProductState> emit) async {
    try {
      add(const LoadingProductEvent());
         await updateProductUsecase(event.product);
 
    } catch (e) {
      add(const LoadingProductEvent());
      emit(FailureLoadingState('Failed to update coupon:$e'));
    }
  }

  Future<void> deleteProduct(
      DeletingProductEvent event, Emitter<ProductState> emit) async {
    try {
      await deleteProductUsecase(event.id);
      await Future.delayed(const Duration(milliseconds: 500));
      add(const LoadingProductEvent());
        
      
      
    } catch (e) {
       add(const LoadingProductEvent());
      emit(FailureLoadingState('Failed to delete coupon:$e'));
    }
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}