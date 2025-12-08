class CategoryDialogCubitState {
  final String? imageUrl;
  final bool isUploading;

  const CategoryDialogCubitState({
    this.imageUrl,
    this.isUploading = false,
  });

  CategoryDialogCubitState copyWith({
    String? imageUrl,
    bool? isUploading,
  }) {
    return CategoryDialogCubitState(
      imageUrl: imageUrl ?? this.imageUrl,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}