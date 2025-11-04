import 'package:rizqmartadmin/features/auth/data/data_sources/main/brand_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/model/brand_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/brand_repository.dart';

class BrandRepositoryImpl implements BrandRepository{
  final BrandFirestoreSource firestoreSource;
  BrandRepositoryImpl(this.firestoreSource);

  @override
  Stream<List<BrandEntity>>getBrands(){ 
    return firestoreSource.getBrands();
  }
  @override
  Future<void>addBrand(BrandEntity brand){
    final model=BrandModel(id: brand.id, name: brand.name, logourl: brand.logourl, description: brand.description, status: brand.status);
    return firestoreSource.addBrand(model); 
  }

  @override
  Future<void>updateBrand(BrandEntity brand)async{
    final model=BrandModel(id: brand.id, name: brand.name, logourl: brand.logourl, description: brand.description, status: brand.status);
    return firestoreSource.updateBrand(model);
  }
  
  @override
  Future<void>deleteBrand(String id)async{
     await firestoreSource.deleteBrand(id);
  }
}