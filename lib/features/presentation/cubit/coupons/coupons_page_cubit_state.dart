class CouponsPageState {
  final String searchQuery;
  final bool isGridView;

  const CouponsPageState({
    this.searchQuery = '',
    this.isGridView = true,
  });

  CouponsPageState copyWith({
    String? searchQuery,
    bool? isGridView,
  }) {
    return CouponsPageState(
      searchQuery: searchQuery ?? this.searchQuery,
      isGridView: isGridView ?? this.isGridView,
    );
  }
}
