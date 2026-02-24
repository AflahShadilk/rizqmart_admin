import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/error_handler.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/data/data_sources/main/unit_firestore_source.dart';
import 'package:rizqmartadmin/features/auth/data/model/units_model.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/units_repository.dart';

class UnitsRepositoryImple implements UnitsRepository {
  final UnitFirestoreSource unitFirestoreSource;
  const UnitsRepositoryImple({required this.unitFirestoreSource});

  @override
  Stream<List<UnitsEntity>> getUnits() {
    return unitFirestoreSource.getVariants();
  }

  @override
  Future<Either<Failure, void>> addUnit(UnitsEntity unit) async {
    final model = UnitsModel(id: unit.id, unitName: unit.unitName, unitType: unit.unitType, wieght: unit.wieght, category: unit.category);
    return ErrorHandler.execute(() => unitFirestoreSource.addUnits(model));
  }

  @override
  Future<Either<Failure, void>> updateUnits(UnitsEntity unit) async {
    final model = UnitsModel(id: unit.id, unitName: unit.unitName, unitType: unit.unitType, wieght: unit.wieght, category: unit.category);
    return ErrorHandler.execute(() => unitFirestoreSource.updateUnits(model));
  }

  @override
  Future<Either<Failure, void>> deleteUnit(String id) async {
    return ErrorHandler.execute(() => unitFirestoreSource.deleteUnit(id));
  }
}