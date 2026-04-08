import 'package:rizqmartadmin/core/error/either.dart';
import 'package:rizqmartadmin/core/error/failures.dart';
import 'package:rizqmartadmin/features/domain/repository/main/units_repository.dart';

class DeleteUnitUsecase {
  final UnitsRepository repository;
  const DeleteUnitUsecase(this.repository);
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteUnit(id);
  }
}