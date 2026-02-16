class ProductSelectionState {
  final List<String> selectedIds;
  final String searchQuery;

  const ProductSelectionState({
    this.selectedIds = const [],
    this.searchQuery = '',
  });

  ProductSelectionState copyWith({
    List<String>? selectedIds,
    String? searchQuery,
  }) {
    return ProductSelectionState(
      selectedIds: selectedIds ?? this.selectedIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
