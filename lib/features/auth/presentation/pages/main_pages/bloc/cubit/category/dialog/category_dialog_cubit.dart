import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/category/dialog/category_dialog_cubit_state.dart';

class CategoryDialogCubit extends Cubit<CategoryDialogCubitState> {
  CategoryDialogCubit() : super(const CategoryDialogCubitState());

  void initializeImage(String? initialImageUrl) {
    if (initialImageUrl != null) {
      emit(state.copyWith(imageUrl: initialImageUrl));
    }
  }

  void setUploading(bool uploading) {
    emit(state.copyWith(isUploading: uploading));
  }

  void updateImage(String imageUrl) {
    emit(state.copyWith(imageUrl: imageUrl, isUploading: false));
  }

  void reset() {
    emit(const CategoryDialogCubitState());
  }
}