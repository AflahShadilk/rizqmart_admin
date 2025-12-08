import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerSelectedIndexCubit extends Cubit<int> {
  DrawerSelectedIndexCubit() : super(0);

  void setSelectedIndex(int index) => emit(index);
}