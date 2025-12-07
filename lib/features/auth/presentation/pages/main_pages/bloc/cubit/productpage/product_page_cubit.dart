import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/productpage/product_page_state.dart';



class ProductsPageCubit extends Cubit<ProductsPageState> {
  ProductsPageCubit() : super(const ProductsPageState());

  void updateFilterProducts(List<AddProductEntity> products) {
    emit(state.copyWith(filterProducts: products));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void reset() {
    emit(const ProductsPageState());
  }
}