import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/sales_report/get_sales_report_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_state.dart';

class SalesReportBloc extends Bloc<SalesReportEvent, SalesReportState> {
  final GetSalesReportUseCase getSalesReportUseCase;

  SalesReportBloc({required this.getSalesReportUseCase}) : super(SalesReportInitial()) {
    on<LoadSalesReportEvent>(_onLoadSalesReport);
  }

  Future<void> _onLoadSalesReport(
    LoadSalesReportEvent event,
    Emitter<SalesReportState> emit,
  ) async {
    emit(SalesReportLoading());
    try {
      final report = await getSalesReportUseCase(event.startDate, event.endDate);
      emit(SalesReportLoaded(report: report));
    } catch (e) {
      emit(SalesReportError(message: e.toString()));
    }
  }
}
