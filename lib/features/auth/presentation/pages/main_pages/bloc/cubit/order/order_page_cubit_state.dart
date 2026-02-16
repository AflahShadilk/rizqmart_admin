class OrderPageState {
  final String selectedFilter;
  final int currentPage;

  const OrderPageState({
    this.selectedFilter = 'all',
    this.currentPage = 1,
  });

  OrderPageState copyWith({
    String? selectedFilter,
    int? currentPage,
  }) {
    return OrderPageState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
