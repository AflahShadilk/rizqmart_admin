import 'package:rizqmartadmin/features/auth/domain/repository/main/units_repository.dart';

class DeleteUnitUsecase {
  final UnitsRepository repository;
  const DeleteUnitUsecase(this.repository);
  Future<void>call(String id)async{
    await repository.deleteUnit(id);
  }
}