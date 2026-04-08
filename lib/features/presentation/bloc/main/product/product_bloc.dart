import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/data/data_sources/services/web_messaging_service.dart';
import 'package:rizqmartadmin/features/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/product/add_product_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/product/delete_product_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/product/get_product_usecase.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/product/update_product_usecase.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/product/product_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUsecase getProductUsecase;
  final AddProductUsecase addProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  StreamSubscription<List<AddProductEntity>>? subscription;
  ProductBloc({required this.getProductUsecase, required this.addProductUsecase, required this.updateProductUsecase, required this.deleteProductUsecase}) : super(LoadingProductState()) {
    on<LoadingProductEvent>(loadingProduct);
    on<LoadedProductEvent>(loadedProduct);
    on<AddingProductEvent>(addingProduct);
    on<UpdatingProductEvent>(updateProduct);
    on<DeletingProductEvent>(deleteProduct);
    add(LoadingProductEvent());
  }

  Future<void> loadingProduct(LoadingProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingProductState());
    subscription?.cancel();
    subscription = getProductUsecase().listen((product) {
      for (var p in product) {
        if (p.variantDetails != null) {
          for (var variant in p.variantDetails!) {
            final quantity = (variant['quantity'] as num?)?.toDouble() ?? 0;
            if (quantity < 5) {
              WebMessagingService.triggerLocalNotification(
                'Low Stock Alert',
                'Product ${p.name} (Variant: ${variant['unitName'] ?? 'Unknown'}) is running low on stock ($quantity).',
                data: {'type': 'product', 'id': p.id},
              );
              break;
            }
          }
        }
      }
      add(LoadedProductEvent(product));
    }, onError: (error) {
      emit(FailureLoadingState(error.toString()));
    });
  }

  void loadedProduct(LoadedProductEvent event, Emitter<ProductState> emit) {
    emit(LoadedProductState(event.product));
  }

  Future<void> addingProduct(AddingProductEvent event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is LoadedProductState) {
      final updatedList = List<AddProductEntity>.from(currentState.product)
        ..add(event.product);
      emit(LoadedProductState(updatedList));
    }
    final result = await addProductUsecase(event.product);
    result.fold(
      (failure) {
        add(const LoadingProductEvent());
        emit(FailureLoadingState(failure.message));
      },
      (_) => emit(SuccessLoadingState('Created new coupon successfully')),
    );
  }

  Future<void> updateProduct(UpdatingProductEvent event, Emitter<ProductState> emit) async {
    add(const LoadingProductEvent());
    final result = await updateProductUsecase(event.product);
    result.fold(
      (failure) {
        add(const LoadingProductEvent());
        emit(FailureLoadingState(failure.message));
      },
      (_) {},
    );
  }

  Future<void> deleteProduct(DeletingProductEvent event, Emitter<ProductState> emit) async {
    final result = await deleteProductUsecase(event.id);
    result.fold(
      (failure) {
        add(const LoadingProductEvent());
        emit(FailureLoadingState(failure.message));
      },
      (_) {
        WebMessagingService.triggerLocalNotification(
          'Product Deleted',
          'Product has been removed from inventory.',
          data: {'type': 'product', 'id': event.id},
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          add(const LoadingProductEvent());
        });
      },
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}