import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/units_repository.dart';

class AddUnitUsecase {
  final UnitsRepository repository;
  const AddUnitUsecase(this.repository);

  Future<void>call(UnitsEntity unit)async{
    await repository.addUnit(unit);
  }
}