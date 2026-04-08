import 'package:equatable/equatable.dart';

/// Entity representing a top-selling product aggregated from order data.
class TopSellingProductEntity extends Equatable {
  final String productId;
  final String name;
  final int totalSold;
  final double totalRevenue;

  const TopSellingProductEntity({
    required this.productId,
    required this.name,
    required this.totalSold,
    required this.totalRevenue,
  });

  @override
  List<Object?> get props => [productId, name, totalSold, totalRevenue];
}
