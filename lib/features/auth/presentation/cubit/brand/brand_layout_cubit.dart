import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/brand/brand_layout_state.dart';

class BrandLayoutCubit extends Cubit<BrandLayoutState> {
  BrandLayoutCubit() : super(BrandLayoutState.initial());

  void toggleView(bool isGrid) {
    emit(BrandLayoutState(isGridView: isGrid));
  }
}
