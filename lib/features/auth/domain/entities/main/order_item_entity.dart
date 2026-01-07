class OrderItemEntity {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}