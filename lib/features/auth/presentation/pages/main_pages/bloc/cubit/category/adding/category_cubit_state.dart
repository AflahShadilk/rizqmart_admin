class CategoryPageState {
  final String searchQuery;

  const CategoryPageState({
    this.searchQuery = '',
  });

  CategoryPageState copyWith({
    String? searchQuery,
  }) {
    return CategoryPageState(
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}