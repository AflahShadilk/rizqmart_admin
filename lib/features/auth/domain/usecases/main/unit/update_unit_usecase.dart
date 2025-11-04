import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/units_repository.dart';

class UpdateUnitUsecase {
  final UnitsRepository repository;
  const UpdateUnitUsecase(this.repository);
  Future<void>call(UnitsEntity unit)async{
    await repository.updateUnits(unit);
  }
}