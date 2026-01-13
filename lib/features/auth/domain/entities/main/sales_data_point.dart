import 'package:equatable/equatable.dart';

class SalesDataPoint extends Equatable {
  final DateTime date;
  final double amount;

  const SalesDataPoint({required this.date, required this.amount});

  @override
  List<Object?> get props => [date, amount];
}
