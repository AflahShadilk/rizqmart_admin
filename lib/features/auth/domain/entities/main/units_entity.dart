import 'package:equatable/equatable.dart';

class UnitsEntity extends Equatable{
  final String id;
  final String unitName; //name like small pack ,big pack 1kg bag
  final String unitType;// kh,Large,piece
  final double wieght;// wieght values
  
  const UnitsEntity({required this.id,required this.unitName,required this.unitType,required this.wieght});

  @override
  List<Object?> get props => [id,unitName,unitType,wieght];
}