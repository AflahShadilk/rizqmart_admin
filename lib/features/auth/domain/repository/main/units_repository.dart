import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';

abstract class UnitsRepository {
  Stream<List<UnitsEntity>> getUnits();
  Future<Either<Failure, void>> addUnit(UnitsEntity unit);
  Future<Either<Failure, void>> updateUnits(UnitsEntity unit);
  Future<Either<Failure, void>> deleteUnit(String id);
}