import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/dashboard/get_dashboard_stats_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  DashboardBloc({required this.getDashboardStatsUseCase}) : super(DashboardInitial()) {
    on<FetchDashboardStatsEvent>(_onFetchStats);
  }

  Future<void> _onFetchStats(
    FetchDashboardStatsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final result = await getDashboardStatsUseCase.call();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (stats) => emit(DashboardLoaded(stats)),
    );
  }
}
