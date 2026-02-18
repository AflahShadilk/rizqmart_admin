import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/salesreport/sales_report_page_cubit_state.dart';

class SalesReportPageCubit extends Cubit<SalesReportPageState> {
  SalesReportPageCubit() : super(SalesReportPageState());

  void updateDateRange(DateTime startDate, DateTime endDate) {
    emit(state.copyWith(startDate: startDate, endDate: endDate));
  }
}
