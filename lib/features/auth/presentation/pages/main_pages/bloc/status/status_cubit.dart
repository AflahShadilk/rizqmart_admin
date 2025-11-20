import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/status/status_state.dart';

class StatusCubit extends Cubit<StatusState>{
  bool currentStatus=false;
  StatusCubit():super(ToggleStatusState(false));
  
  void initializeStatus(bool initialStatus) {
    currentStatus = initialStatus;
    emit(ToggleStatusState(currentStatus));
  }
  
  void toggleStatus(){
    emit(LoadingStatusState());
    Future.delayed(Duration(milliseconds: 300),(){
      currentStatus=!currentStatus;
      emit(ToggleStatusState(currentStatus));
    });
  }
}