import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';
import 'package:rizqmartadmin/features/auth/domain/repository/main/units_repository.dart';

class GetUnitsUsecase {
  UnitsRepository repository;
  GetUnitsUsecase(this.repository);
  Stream<List<UnitsEntity>>call(){
    return repository.getUnits();
  }
}