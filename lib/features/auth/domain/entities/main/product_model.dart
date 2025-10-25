import 'package:equatable/equatable.dart';

class AddProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final double mrp;
  final String? description;
  final String category;
  final String brand;
  final double quantity;
  final double? discount;
  final List<String> variant;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime? updateAt;
  final bool ?features;
  final bool ? status;
 const AddProductEntity(
      {
        required this.id,
        required this.name,
      required this.price,
      required this.mrp,
       this.description,
      required this.category,
      required this.brand,
      required this.quantity,
      this.discount,
      required this.variant,
      required this.imageUrls,
      required this.createdAt,
      this.updateAt,
      this.features,
      this.status
      });

  @override

  List<Object?> get props => [id,name,price,description,category,brand,quantity,discount,variant,imageUrls,createdAt,updateAt,features,status];    
}
