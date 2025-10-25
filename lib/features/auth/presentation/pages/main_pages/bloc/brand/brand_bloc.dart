import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/brand/add_brand_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/brand/delete_brand_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/brand/get_brand_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/brand/update_brand_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_event.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final GetBrandUsecases getBrandUsecase;
  final AddBrandUsecase  addBrandUsecase;
  final UpdateBrandUsecase updateBrandUsecase;
  final DeleteBrandUsecase deleteBrandUsecase;
  StreamSubscription<List<BrandEntity>>? brandsSubscription;

  BrandBloc({required this.getBrandUsecase,required this.addBrandUsecase,required this.updateBrandUsecase,required this.deleteBrandUsecase}) : super(BrandLoadingState()) {
    on<UploadingBrandEvent>(uploadingBrands);
    on<UploadedBrandEvent>(uploadedBrand);
    on<AddBrandEvent>(addBrand);
    on<UpdateBrandEvent>(updateBrand);
    on<DeleteBrandEvent>(deleteBrand);
    add(UploadingBrandEvent());
  }
  void uploadingBrands(UploadingBrandEvent event, Emitter<BrandState> emit) {
    emit(BrandLoadingState());
    brandsSubscription?.cancel();
    brandsSubscription = getBrandUsecase().listen((brands) {
      add(UploadedBrandEvent(brands));

    });
  }

  void uploadedBrand(UploadedBrandEvent event, Emitter<BrandState> emit) {
    emit(BrandLoadedState(event.products));
  }

 Future <void> addBrand(AddBrandEvent event, Emitter<BrandState> emit) async {
    try{
      final currentState=state;
      if(currentState is BrandLoadedState){
        final updatedList=List<BrandEntity>.from(currentState.brand)
        ..add(event.brandEntity);
        emit(BrandLoadedState(updatedList));
      }
    await addBrandUsecase(event.brandEntity);
    
    emit(BrandLoadingSuccessState('Brand added successfully'));
    }catch(e){
      emit(BrandFailureState('Adding failed: $e'));
    }
  }
  
  Future<void>updateBrand(UpdateBrandEvent event,Emitter<BrandState>emit)async{
    try{
      await updateBrandUsecase(event.brandEntity);
    emit(BrandLoadingSuccessState('Brand Updating successfully'));

    }catch(e){
      emit(BrandFailureState('Updating failed: $e'));
       
    }
  }

  Future<void>deleteBrand(DeleteBrandEvent event,Emitter<BrandState>emit)async{
    try{
      add(UploadingBrandEvent());
      await deleteBrandUsecase(event.id);
    // emit(BrandLoadingSuccessState('Brand Deleting successfully'));

    }catch(e){
      emit(BrandFailureState('Deleting failed: $e'));

    }
  }

  @override
  Future<void> close() {
    brandsSubscription?.cancel();
    return super.close();
  }
}
