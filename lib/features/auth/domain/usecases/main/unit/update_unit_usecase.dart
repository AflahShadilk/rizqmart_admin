import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/units_repository.dart';

class UpdateUnitUsecase {
  final UnitsRepository repository;
  const UpdateUnitUsecase(this.repository);
  Future<Either<Failure, void>> call(UnitsEntity unit) async {
    return await repository.updateUnits(unit);
  }
}