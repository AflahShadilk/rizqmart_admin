class UnitSearchState {
  final String searchQuery;
  final bool isGridView;

  const UnitSearchState({
    this.searchQuery = '',
    this.isGridView = true,
  });

  UnitSearchState copyWith({
    String? searchQuery,
    bool? isGridView,
  }) {
    return UnitSearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      isGridView: isGridView ?? this.isGridView,
    );
  }
}
