import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/salesreport/sales_report_page_cubit_state.dart';

class SalesReportPageCubit extends Cubit<SalesReportPageState> {
  SalesReportPageCubit() : super(SalesReportPageState());

  void updateDateRange(DateTime startDate, DateTime endDate) {
    emit(state.copyWith(
      startDate: startDate,
      endDate: endDate,
      selectedFilter: SalesFilter.custom,
    ));
  }

  void setToday() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    emit(state.copyWith(
      startDate: startOfDay,
      endDate: now,
      selectedFilter: SalesFilter.today,
    ));
  }

  void setThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    emit(state.copyWith(
      startDate: start,
      endDate: now,
      selectedFilter: SalesFilter.thisWeek,
    ));
  }

  void setThisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    emit(state.copyWith(
      startDate: startOfMonth,
      endDate: now,
      selectedFilter: SalesFilter.thisMonth,
    ));
  }
}
