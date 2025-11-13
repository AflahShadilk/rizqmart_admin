// Get images
List<String> getVariantImages(dynamic widget) {
  List<String> imageUrls = [];
  if (widget.product.variantDetails != null && 
      widget.product.variantDetails!.isNotEmpty) {
    for (var variant in widget.product.variantDetails!) {
      final imageUrl = variant['imageUrls'] as List?;
      if (imageUrl != null) {
        imageUrls.addAll(imageUrl.whereType<String>());
      }
    }
  }
  return imageUrls;
}

// Get prices
List<double> getVariantPrices(dynamic widget) {
  List<double> prices = [];
  if (widget.product.variantDetails != null) {
    for (var variant in widget.product.variantDetails!) {
      prices.add(variant['price'] as double? ?? 0.0);
    }
  }
  return prices;
}

// Get Mrp
List<double> getVariantMrp(dynamic widget) {
  List<double> mrps = [];
  if (widget.product.variantDetails != null) {
    for (var variant in widget.product.variantDetails!) {
      mrps.add(variant['mrp'] as double? ?? 0.0);
    }
  }
  return mrps;
}

// Get quantities
List<double> getVariantQuantities(dynamic widget) {
  List<double> quantities = [];
  if (widget.product.variantDetails != null) {
    for (var variant in widget.product.variantDetails!) {
      quantities.add(variant['quantity'] as double? ?? 0.0);
    }
  }
  return quantities;
}

// Get unit names
List<String> getVariantNames(dynamic widget) {
  List<String> names = [];
  if (widget.product.variantDetails != null) {
    for (var variant in widget.product.variantDetails!) {
      names.add(variant['unitName'] as String? ?? '');
    }
  }
  return names;
}