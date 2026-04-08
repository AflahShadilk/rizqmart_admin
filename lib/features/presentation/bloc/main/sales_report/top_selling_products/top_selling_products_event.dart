import 'package:equatable/equatable.dart';

/// Events for the TopSellingProducts BLoC.
abstract class TopSellingProductsEvent extends Equatable {
  const TopSellingProductsEvent();

  @override
  List<Object> get props => [];
}

/// Event to load top-selling products for a given date range.
class LoadTopSellingProducts extends TopSellingProductsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadTopSellingProducts({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}
