class PaymentPageState {
  final String selectedFilter;
  final int currentPage;

  const PaymentPageState({
    this.selectedFilter = 'all',
    this.currentPage = 1,
  });

  PaymentPageState copyWith({
    String? selectedFilter,
    int? currentPage,
  }) {
    return PaymentPageState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
