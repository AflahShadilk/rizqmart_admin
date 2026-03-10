enum SalesFilter { today, thisWeek, thisMonth, custom }

class ReportState {
  final DateTime startDate;
  final DateTime endDate;
  final SalesFilter selectedFilter;

  ReportState({
    DateTime? startDate,
    DateTime? endDate,
    this.selectedFilter = SalesFilter.thisMonth,
  })  : startDate = startDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1),
        endDate = endDate ?? DateTime.now();

  ReportState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    SalesFilter? selectedFilter,
  }) {
    return ReportState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
