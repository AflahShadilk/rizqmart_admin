import 'package:equatable/equatable.dart';

class SalesDataPoint extends Equatable {
  final DateTime date;
  final double amount;
  final int orderCount;

  const SalesDataPoint({required this.date, required this.amount, this.orderCount = 0});

  @override
  List<Object?> get props => [date, amount, orderCount];
}

