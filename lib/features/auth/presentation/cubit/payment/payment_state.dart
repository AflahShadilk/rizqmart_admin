import 'package:equatable/equatable.dart';

class PaymentCubitState extends Equatable {
  final int currentPage;
  final String selectedFilter;
  final bool isGridView;

  const PaymentCubitState({
    required this.currentPage,
    required this.selectedFilter,
    required this.isGridView,
  });

  factory PaymentCubitState.initial() {
    return const PaymentCubitState(
      currentPage: 1,
      selectedFilter: 'all',
      isGridView: true,
    );
  }

  PaymentCubitState copyWith({
    int? currentPage,
    String? selectedFilter,
    bool? isGridView,
  }) {
    return PaymentCubitState(
      currentPage: currentPage ?? this.currentPage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isGridView: isGridView ?? this.isGridView,
    );
  }

  @override
  List<Object?> get props => [currentPage, selectedFilter, isGridView];
}
