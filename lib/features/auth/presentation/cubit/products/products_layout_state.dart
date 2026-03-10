abstract class ProductsLayoutStateBase {
  const ProductsLayoutStateBase();
}

class ProductsLayoutState extends ProductsLayoutStateBase {
  final bool isGridView;

  const ProductsLayoutState({required this.isGridView});
}
