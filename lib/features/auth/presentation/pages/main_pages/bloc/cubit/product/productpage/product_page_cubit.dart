import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/product/productpage/product_page_state.dart';



class ProductsPageCubit extends Cubit<ProductsPageState> {
  ProductsPageCubit() : super(const ProductsPageState());

  void updateFilterProducts(List<AddProductEntity> products) {
    emit(state.copyWith(filterProducts: products, currentPage: 1));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query, currentPage: 1));
  }

  void nextPage(int totalItems) {
    final maxPage = (totalItems / state.itemsPerPage).ceil();
    if (state.currentPage < maxPage) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void previousPage() {
    if (state.currentPage > 1) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void goToPage(int page, int totalItems) {
    final maxPage = (totalItems / state.itemsPerPage).ceil();
    if (page >= 1 && page <= maxPage) {
      emit(state.copyWith(currentPage: page));
    }
  }

  void resetPage() {
    emit(state.copyWith(currentPage: 1));
  }

  void reset() {
    emit(const ProductsPageState());
  }
}
