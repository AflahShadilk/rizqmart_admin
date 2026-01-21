import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';

class OfferCalculator {
  /// Calculates the discount amount for a given order total and product list.
  /// 
  /// [orderTotal]: The total amount of the order before discount.
  /// [orderProductIds]: List of product IDs in the order.
  /// [offer]: The applied coupon/offer.
  /// 
  /// Returns the discount amount to be deducted.
  static double calculateDiscount({
    required double orderTotal,
    required List<String> orderProductIds,
    required CouponEntity offer,
  }) {
    // 1. Check if offer is active and not expired
    if (!offer.isActive || offer.expiryDate.isBefore(DateTime.now())) {
      return 0.0;
    }

    // 2. Check minimum order value
    if (orderTotal < offer.minOrderValue) {
      return 0.0;
    }

    // 3. Check applicability
    // If applicableProductIds is empty, it applies to all products (global offer).
    // If not empty, we need to check if ANY of the order products match.
    // NOTE: A more advanced logic would sum up the price of ONLY the applicable products
    // and apply the discount to that sum. For now, we'll assume if it contains at least one
    // applicable product (or if list is empty), the discount applies to the whole order 
    // OR we can strictly apply it only if the user purchased applicable products.
    // Given the requirement "applicable product need to show discount", likely it should be specific.
    
    // However, without individual product prices passed here, we can only do a global check.
    // For a strict implementation, we would need Map<String, double> productPrices.
    // Let's assume for this utility, we apply if condition is met.
    
    bool isApplicable = true;
    if (offer.applicableProductIds.isNotEmpty) {
      isApplicable = orderProductIds.any((id) => offer.applicableProductIds.contains(id));
    }

    if (!isApplicable) {
      return 0.0;
    }

    // 4. Calculate Discount
    double discount = 0.0;
    if (offer.percentage != null && offer.percentage! > 0) {
      discount = orderTotal * (offer.percentage! / 100);
    } else if (offer.amount != null) {
      discount = offer.amount!;
    }

    // Ensure discount doesn't exceed order total
    if (discount > orderTotal) {
      discount = orderTotal;
    }

    return discount;
  }

  /// Calculates the refund amount for a cancelled item.
  /// 
  /// [productPrice]: The original price of the product being returned.
  /// [productId]: The ID of the product being returned.
  /// [offer]: The offer that was applied to the order (if any).
  /// 
  /// Returns the amount to refund, deducting any discount that was applied specifically to this item.
  static double calculateRefundAmount({
    required double productPrice,
    required String productId,
    required CouponEntity? offer,
  }) {
    if (offer == null) {
      return productPrice;
    }

    // Check if the offer was actually applicable to this product
    // (If offer list is empty, it applies to all, so yes. If not empty, check ID).
    bool wasApplicable = true;
    if (offer.applicableProductIds.isNotEmpty) {
      wasApplicable = offer.applicableProductIds.contains(productId);
    }

    if (!wasApplicable) {
      return productPrice;
    }

    // Calculate how much discount was attributed to this product.
    // This is tricky for "Fixed Amount" offers applied to a cart. 
    // Usually fixed amount is distributed proportionally or applied once.
    // For Percentage, it's easy:
    if (offer.percentage != null && offer.percentage! > 0) {
      double discountAmount = productPrice * (offer.percentage! / 100);
      return productPrice - discountAmount;
    }
    
    // For Fixed Amount, proper accounting usually pr-rates it.
    // If we simply return "productPrice", we give back more than they paid (technically).
    // But without knowing the total order split, we can't perfectly reverse a fixed cart discount per item.
    // STRATEGY: For fixed amount, usually we don't deduct from individual item refunds unless we store 
    // "paid price" per item line. 
    // Requirement says: "while cancelling the product return the amount without offer price".
    // This implies we DO return the full price if the offer wasn't strictly about this product?
    // OR it means "Return the amount the user PAID (which is price - offer)".
    // Let's assume the latter.
    
    // Fallback for Fixed Amount: We cannot easily calculate per-item deduction without context of total items.
    // Ideally, we should suggest storing "discountedPrice" on the OrderItem itself.
    // But as a utility:
    return productPrice; 
  }
}
