import 'package:equatable/equatable.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/top_selling_product_entity.dart';

/// States for the TopSellingProducts BLoC.
abstract class TopSellingProductsState extends Equatable {
  const TopSellingProductsState();

  @override
  List<Object> get props => [];
}

/// Initial state before any data is loaded.
class TopSellingProductsInitial extends TopSellingProductsState {}

/// Loading state while fetching data from repository.
class TopSellingProductsLoading extends TopSellingProductsState {}

/// Loaded state with a list of top-selling products.
class TopSellingProductsLoaded extends TopSellingProductsState {
  final List<TopSellingProductEntity> products;

  const TopSellingProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

/// Error state when fetch fails.
class TopSellingProductsError extends TopSellingProductsState {
  final String message;

  const TopSellingProductsError({required this.message});

  @override
  List<Object> get props => [message];
}
