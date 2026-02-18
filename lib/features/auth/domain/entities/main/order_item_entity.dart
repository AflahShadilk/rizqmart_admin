class OrderItemEntity {
  final String productId;
  final String productName;
  final double price;
  final double quantity; // Changed from int to double
  final String imageUrl;
  final String? variantId; // Added
  final String? unit; // Added

  OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.variantId,
    this.unit,
  });
}