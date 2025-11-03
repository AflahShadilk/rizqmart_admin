class ProductTextValidators {
  //Product name — required, at least 3 characters
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter product name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  } 

  // Description — required, at least 10 characters
  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter product description';
    }
    if (value.trim().length < 3) {
      return 'Description should be at least 10 characters';
    }
    return null;
  }

  //Price — required, numeric, greater than 0
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter price';
    }
    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Enter a valid number';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  // Stock — required, integer, cannot be negative
  static String? stock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter stock quantity';
    }
    final qty = int.tryParse(value.trim());
    if (qty == null) {
      return 'Enter a valid number';
    }
    if (qty < 0) {
      return 'Stock cannot be negative';
    }
    return null;
  }
}
