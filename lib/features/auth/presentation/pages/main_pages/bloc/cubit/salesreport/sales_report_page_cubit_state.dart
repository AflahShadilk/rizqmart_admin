class SalesReportPageState {
  final DateTime startDate;
  final DateTime endDate;

  SalesReportPageState({
    DateTime? startDate,
    DateTime? endDate,
  })  : startDate = startDate ?? DateTime.now().subtract(const Duration(days: 30)),
        endDate = endDate ?? DateTime.now();

  SalesReportPageState copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SalesReportPageState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
