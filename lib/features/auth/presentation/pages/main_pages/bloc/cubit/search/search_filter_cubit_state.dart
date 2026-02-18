class SearchFilterState {
  final String? selectedCategory;
  final String? selectedBrand;

  const SearchFilterState({
    this.selectedCategory,
    this.selectedBrand,
  });

  SearchFilterState copyWith({
    String? selectedCategory,
    String? selectedBrand,
    bool clearCategory = false,
    bool clearBrand = false,
  }) {
    return SearchFilterState(
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedBrand: clearBrand ? null : (selectedBrand ?? this.selectedBrand),
    );
  }
}
