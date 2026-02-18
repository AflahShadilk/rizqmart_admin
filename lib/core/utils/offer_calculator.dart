import 'package:rizqmartadmin/features/auth/domain/entities/main/coupon_entity.dart';

class OfferCalculator {
  /// Calculates the discount amount for a given order total and product list.
  static double calculateDiscount({
    required double orderTotal,
    required List<String> orderProductIds,
    required CouponEntity offer,
  }) {
    if (!offer.isActive || offer.expiryDate.isBefore(DateTime.now())) {
      return 0.0;
    }

    if (orderTotal < offer.minOrderValue) {
      return 0.0;
    }

    bool isApplicable = true;
    if (offer.applicableProductIds.isNotEmpty) {
      isApplicable = orderProductIds.any((id) => offer.applicableProductIds.contains(id));
    }

    if (!isApplicable) {
      return 0.0;
    }

    double discount = 0.0;
    if (offer.percentage != null && offer.percentage! > 0) {
      discount = orderTotal * (offer.percentage! / 100);
    } else if (offer.amount != null) {
      discount = offer.amount!;
    }

    if (discount > orderTotal) {
      discount = orderTotal;
    }

    return discount;
  }

  /// Calculates the refund amount for a cancelled item, deducting any applicable discount.
  static double calculateRefundAmount({
    required double productPrice,
    required String productId,
    required CouponEntity? offer,
  }) {
    if (offer == null) {
      return productPrice;
    }

    bool wasApplicable = true;
    if (offer.applicableProductIds.isNotEmpty) {
      wasApplicable = offer.applicableProductIds.contains(productId);
    }

    if (!wasApplicable) {
      return productPrice;
    }

    if (offer.percentage != null && offer.percentage! > 0) {
      double discountAmount = productPrice * (offer.percentage! / 100);
      return productPrice - discountAmount;
    }

    return productPrice;
  }
}
