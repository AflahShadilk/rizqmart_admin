import 'package:rizqmartadmin/features/domain/entities/main/top_selling_product_entity.dart';

/// Data model for top-selling products, extends the domain entity.
class TopSellingProductModel extends TopSellingProductEntity {
  const TopSellingProductModel({
    required super.productId,
    required super.name,
    required super.totalSold,
    required super.totalRevenue,
  });
}
