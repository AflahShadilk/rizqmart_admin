import 'package:flutter_bloc/flutter_bloc.dart';
import 'products_layout_state.dart';

class ProductsLayoutCubit extends Cubit<ProductsLayoutState> {
  ProductsLayoutCubit() : super(const ProductsLayoutState(isGridView: true));

  void toggleView(bool isGridView) {
    emit(ProductsLayoutState(isGridView: isGridView));
  }
}
