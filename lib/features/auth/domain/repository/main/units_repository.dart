import 'package:rizqmartadmin/features/auth/domain/entities/main/units_entity.dart';

abstract class UnitsRepository {
  Stream<List<UnitsEntity>>getUnits();
  Future<void>addUnit(UnitsEntity unit);
  Future<void>updateUnits(UnitsEntity unit);
  Future<void>deleteUnit(String id);
}