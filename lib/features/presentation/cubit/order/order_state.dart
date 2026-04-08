import 'package:equatable/equatable.dart';

class OrderState extends Equatable {
  final String selectedFilter;
  final int currentPage;
  final bool isGridView;
  final int itemsPerPage;

  const OrderState({
    this.selectedFilter = 'all',
    this.currentPage = 1,
    this.isGridView = true,
    this.itemsPerPage = 12,
  });

  OrderState copyWith({
    String? selectedFilter,
    int? currentPage,
    bool? isGridView,
    int? itemsPerPage,
  }) {
    return OrderState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
      isGridView: isGridView ?? this.isGridView,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }

  @override
  List<Object> get props => [selectedFilter, currentPage, isGridView, itemsPerPage];
}
