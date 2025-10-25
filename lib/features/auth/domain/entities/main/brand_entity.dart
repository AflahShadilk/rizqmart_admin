
import 'package:equatable/equatable.dart';

class BrandEntity extends Equatable{
  final String id;
  final String name;
  final String logourl;
  final String description;
  final bool status;
  
 const BrandEntity(
      {required this.id,
      required this.name,
      required this.logourl,
      required this.description,
      required this.status,
      });

   @override
  
  List<Object?> get props =>[id,name,logourl,description,status];   
}
