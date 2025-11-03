String? validatePrice(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a price';
  }

  final priceRegex = RegExp(r'^\d+(\.\d{1,2})?$'); 
  if (!priceRegex.hasMatch(value.trim())) {
    return 'Enter a valid price';
  }

  if (double.tryParse(value)! <= 0) {
    return 'Price must be greater than zero';
  }

  return null;
}
