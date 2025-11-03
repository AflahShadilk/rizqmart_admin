import 'package:equatable/equatable.dart';

class CouponEntity extends Equatable{
  final String id;
  final String name;
  final double? amount;
  final double? percentage;
  final double minOrderValue;
  final String imageurl;
  final int usageLimit;
  final bool isActive;
  final DateTime expiryDate;
 const CouponEntity(
      {required this.id,
      required this.name,
      this.amount,
      this.percentage,
      required this.minOrderValue,
      required this.imageurl,
      required this.usageLimit,
      required this.isActive,
      required this.expiryDate});

  @override

  List<Object?> get props => [id,name,amount,percentage,minOrderValue,imageurl,usageLimit,isActive,expiryDate];    


}
