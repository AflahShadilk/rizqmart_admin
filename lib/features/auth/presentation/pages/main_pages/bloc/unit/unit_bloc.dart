import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/unit/add_unit_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/unit/delete_unit_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/unit/get_units_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/unit/update_unit_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_state.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  final GetUnitsUsecase getUnitsUsecase;
  final AddUnitUsecase addUnitUsecase;
  final UpdateUnitUsecase updateUnitUsecase;
  final DeleteUnitUsecase deleteUnitUsecase;
  StreamSubscription<List<UnitsEntity>>? unitstream;
  UnitBloc(
      {required this.getUnitsUsecase,
      required this.addUnitUsecase,
      required this.updateUnitUsecase,
      required this.deleteUnitUsecase})
      : super(UnitLoadingState()) {
    on<UnitLoadingEvent>(loadingUnits);
    on<GetUnitbyCategoryEvent>(getUnitBycategory);
    on<UnitLoadedEvent>(loadedUnits);
    on<UnitAddingEvent>(addingUnit);
    on<UnitUpdatingEvent>(updatingUnit);
    on<UnitDeletingEvent>(deleteUnit);
    add(UnitLoadingEvent());
  }
  void loadingUnits(UnitLoadingEvent event, Emitter<UnitState> emit) {
    emit(UnitLoadingState());
    unitstream?.cancel();
    unitstream = getUnitsUsecase().listen((units) {
      add(UnitLoadedEvent(units));
    });
  }

  void getUnitBycategory(
      GetUnitbyCategoryEvent event, Emitter<UnitState> emit) {
    emit(UnitLoadingState());
    unitstream?.cancel();
    unitstream = getUnitsUsecase().listen((allunit){
    final categoryUnit=allunit.where((unit)=>unit.category==event.categoryId).toList();
    add(UnitLoadedEvent(categoryUnit));
    });
   
  }

  void loadedUnits(UnitLoadedEvent event, Emitter<UnitState> emit) {
    emit(UnitLoadedState(event.unit));
  }

  Future<void> addingUnit(
      UnitAddingEvent event, Emitter<UnitState> emit) async {
    await addUnitUsecase(event.unitsEntity);
    add(UnitLoadingEvent());
  }

  Future<void> updatingUnit(
      UnitUpdatingEvent event, Emitter<UnitState> emit) async {
    await updateUnitUsecase(event.unitsEntity);
    add(UnitLoadingEvent());
  }

  Future<void> deleteUnit(
      UnitDeletingEvent event, Emitter<UnitState> emit) async {
    await deleteUnitUsecase(event.id);
    add(UnitLoadingEvent());
  }
}
