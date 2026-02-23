class OrderItemEntity {
  final String productId;
  final String productName;
  final String? brand;
  final double mrp;
  final double price;
  final double quantity; // count from Firestore
  final String imageUrl;
  final String? variantId;
  final String? unit;

  OrderItemEntity({
    required this.productId,
    required this.productName,
    this.brand,
    required this.mrp,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.variantId,
    this.unit,
  });
}