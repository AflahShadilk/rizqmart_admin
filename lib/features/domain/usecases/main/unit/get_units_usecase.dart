import 'package:rizqmartadmin/features/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/domain/repository/main/units_repository.dart';

class GetUnitsUsecase {
  UnitsRepository repository;
  GetUnitsUsecase(this.repository);
  Stream<List<UnitsEntity>>call(){
    return repository.getUnits();
  }
}