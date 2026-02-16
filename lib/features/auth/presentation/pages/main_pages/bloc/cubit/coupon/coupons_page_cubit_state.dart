class CouponsPageState {
  final String searchQuery;

  const CouponsPageState({
    this.searchQuery = '',
  });

  CouponsPageState copyWith({
    String? searchQuery,
  }) {
    return CouponsPageState(
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
