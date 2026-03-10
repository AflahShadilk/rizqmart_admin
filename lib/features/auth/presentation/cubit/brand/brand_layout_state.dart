class BrandLayoutState {
  final bool isGridView;

  BrandLayoutState({required this.isGridView});

  factory BrandLayoutState.initial() {
    return BrandLayoutState(isGridView: true);
  }
}
