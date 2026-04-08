import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/features/data/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/data/data_sources/main/brand_firestore_source.dart';
import 'package:rizqmartadmin/features/data/models/brand_model.dart';
import 'package:rizqmartadmin/features/domain/entities/main/brand_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/brand_repository.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandFirestoreSource firestoreSource;
  BrandRepositoryImpl(this.firestoreSource);

  @override
  Stream<List<BrandEntity>> getBrands() {
    return firestoreSource.getBrands();
  }

  @override
  Future<Either<Failure, void>> addBrand(BrandEntity brand) async {
    final model = BrandModel(id: brand.id, name: brand.name, logourl: brand.logourl, description: brand.description, status: brand.status);
    return ErrorHandler.execute(() => firestoreSource.addBrand(model));
  }

  @override
  Future<Either<Failure, void>> updateBrand(BrandEntity brand) async {
    final model = BrandModel(id: brand.id, name: brand.name, logourl: brand.logourl, description: brand.description, status: brand.status);
    return ErrorHandler.execute(() => firestoreSource.updateBrand(model));
  }

  @override
  Future<Either<Failure, void>> deleteBrand(String id) async {
    return ErrorHandler.execute(() => firestoreSource.deleteBrand(id));
  }
}