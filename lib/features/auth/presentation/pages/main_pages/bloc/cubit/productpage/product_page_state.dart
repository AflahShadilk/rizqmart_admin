import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';

class ProductsPageState {
  final List<AddProductEntity> filterProducts;
  final String searchQuery;

  const ProductsPageState({
    this.filterProducts = const [],
    this.searchQuery = '',
  });

  ProductsPageState copyWith({
    List<AddProductEntity>? filterProducts,
    String? searchQuery,
  }) {
    return ProductsPageState(
      filterProducts: filterProducts ?? this.filterProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}