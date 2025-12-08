class BrandPageCubitState {
  final String searchQuery;

  const BrandPageCubitState({
    this.searchQuery = '',
  });

  BrandPageCubitState copyWith({
    String? searchQuery,
  }) {
    return BrandPageCubitState(
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}