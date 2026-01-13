import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/sales_report_entity.dart';

abstract class SalesReportState extends Equatable {
  const SalesReportState();
  
  @override
  List<Object> get props => [];
}

class SalesReportInitial extends SalesReportState {}

class SalesReportLoading extends SalesReportState {}

class SalesReportLoaded extends SalesReportState {
  final SalesReportEntity report;

  const SalesReportLoaded({required this.report});

  @override
  List<Object> get props => [report];
}

class SalesReportError extends SalesReportState {
  final String message;

  const SalesReportError({required this.message});

  @override
  List<Object> get props => [message];
}
