import 'package:equatable/equatable.dart';

class CouponsState extends Equatable {
  final bool isGridView;
  final String searchQuery;

  const CouponsState({
    required this.isGridView,
    required this.searchQuery,
  });

  factory CouponsState.initial() {
    return const CouponsState(
      isGridView: true,
      searchQuery: '',
    );
  }

  CouponsState copyWith({
    bool? isGridView,
    String? searchQuery,
  }) {
    return CouponsState(
      isGridView: isGridView ?? this.isGridView,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [isGridView, searchQuery];
}
