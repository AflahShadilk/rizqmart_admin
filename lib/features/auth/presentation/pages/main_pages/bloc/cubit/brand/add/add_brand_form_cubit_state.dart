class AddBrandFormCubitState {
  final String? imageUrl;
  final bool status;
  final bool isUploading;

  const AddBrandFormCubitState({
    this.imageUrl,
    this.status = true,
    this.isUploading = false,
  });

  AddBrandFormCubitState copyWith({
    String? imageUrl,
    bool? status,
    bool? isUploading,
  }) {
    return AddBrandFormCubitState(
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
