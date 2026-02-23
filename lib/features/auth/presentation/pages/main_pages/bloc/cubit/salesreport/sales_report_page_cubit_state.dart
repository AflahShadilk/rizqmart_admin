enum SalesFilter { today, thisWeek, thisMonth, custom }

class SalesReportPageState {
  final DateTime startDate;
  final DateTime endDate;
  final SalesFilter selectedFilter;

  SalesReportPageState({
    DateTime? startDate,
    DateTime? endDate,
    this.selectedFilter = SalesFilter.thisMonth,
  })  : startDate = startDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1),
        endDate = endDate ?? DateTime.now();

  SalesReportPageState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    SalesFilter? selectedFilter,
  }) {
    return SalesReportPageState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
