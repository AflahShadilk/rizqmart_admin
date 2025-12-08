import 'package:flutter_bloc/flutter_bloc.dart';

class UnitDialogCategoryCubit extends Cubit<String?> {
  // ignore: use_super_parameters
  UnitDialogCategoryCubit(String? initialCategory) : super(initialCategory);

  void setCategory(String? category) => emit(category);
}

class UnitDialogLoadingCubit extends Cubit<bool> {
  UnitDialogLoadingCubit() : super(false);

  void setLoading(bool isLoading) => emit(isLoading);
}