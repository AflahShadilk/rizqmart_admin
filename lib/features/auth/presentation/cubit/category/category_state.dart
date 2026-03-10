import 'package:equatable/equatable.dart';

abstract class CategoryLayoutState extends Equatable {
  final bool isGridView;

  const CategoryLayoutState({required this.isGridView});

  @override
  List<Object> get props => [isGridView];
}

class CategoryLayoutInitial extends CategoryLayoutState {
  const CategoryLayoutInitial({required super.isGridView});
}

class CategoryLayoutUpdated extends CategoryLayoutState {
  const CategoryLayoutUpdated({required super.isGridView});
}
