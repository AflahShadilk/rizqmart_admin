import 'package:rizqmartadmin/features/auth/domain/entities/main/product_model.dart';

class ProductsPageState {
  final List<AddProductEntity> filterProducts;
  final String searchQuery;
  final int currentPage;
  final int itemsPerPage;

  const ProductsPageState({
    this.filterProducts = const [],
    this.searchQuery = '',
    this.currentPage = 1,
    this.itemsPerPage = 10,
  });

  ProductsPageState copyWith({
    List<AddProductEntity>? filterProducts,
    String? searchQuery,
    int? currentPage,
    int? itemsPerPage,
  }) {
    return ProductsPageState(
      filterProducts: filterProducts ?? this.filterProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}
