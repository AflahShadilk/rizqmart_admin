import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/domain/usecases/main/sales_report/get_top_selling_products_usecase.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/top_selling_products/top_selling_products_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/sales_report/top_selling_products/top_selling_products_state.dart';

/// BLoC responsible for managing the top-selling products state.
class TopSellingProductsBloc extends Bloc<TopSellingProductsEvent, TopSellingProductsState> {
  final GetTopSellingProductsUseCase getTopSellingProductsUseCase;

  TopSellingProductsBloc({required this.getTopSellingProductsUseCase})
      : super(TopSellingProductsInitial()) {
    on<LoadTopSellingProducts>(_onLoadTopSellingProducts);
  }

  Future<void> _onLoadTopSellingProducts(
    LoadTopSellingProducts event,
    Emitter<TopSellingProductsState> emit,
  ) async {
    emit(TopSellingProductsLoading());
    final result = await getTopSellingProductsUseCase(
      event.startDate,
      event.endDate,
    );
    result.fold(
      (failure) => emit(TopSellingProductsError(message: failure.message)),
      (products) => emit(TopSellingProductsLoaded(products: products)),
    );
  }
}
