import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/units_repository.dart';

class AddUnitUsecase {
  final UnitsRepository repository;
  const AddUnitUsecase(this.repository);

  Future<Either<Failure, void>> call(UnitsEntity unit) async {
    return await repository.addUnit(unit);
  }
}