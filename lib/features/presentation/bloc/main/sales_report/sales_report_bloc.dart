import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/sales_report/get_sales_report_usecase.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/sales_report_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/sales_report_state.dart';

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
    final result = await getSalesReportUseCase(event.startDate, event.endDate);
    result.fold(
      (failure) => emit(SalesReportError(message: failure.message)),
      (report) => emit(SalesReportLoaded(report: report)),
    );
  }
}
