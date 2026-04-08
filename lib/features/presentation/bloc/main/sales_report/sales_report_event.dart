import 'package:equatable/equatable.dart';

abstract class SalesReportEvent extends Equatable {
  const SalesReportEvent();

  @override
  List<Object> get props => [];
}

class LoadSalesReportEvent extends SalesReportEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadSalesReportEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}
