import 'package:flutter_bloc/flutter_bloc.dart';

class AddBrandFormCubit extends Cubit<AddBrandFormCubitState> {
  AddBrandFormCubit({
    String? imageUrl,
    bool status = true,
    bool isUploading = false,
  }) : super(AddBrandFormCubitState(
          imageUrl: imageUrl,
          status: status,
          isUploading: isUploading,
        ));

  void setUploading(bool value) {
    emit(state.copyWith(isUploading: value));
  }

  void setImage(String? url) {
    emit(state.copyWith(imageUrl: url));
  }

  void setStatus(bool val) {
    emit(state.copyWith(status: val));
  }
}

class AddBrandFormCubitState {
  final String? imageUrl;
  final bool status;
  final bool isUploading;

  const AddBrandFormCubitState({
    this.imageUrl,
    required this.status,
    required this.isUploading,
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
