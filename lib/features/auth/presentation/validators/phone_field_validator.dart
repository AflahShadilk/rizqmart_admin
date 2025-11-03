String? validatePhoneNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a phone number';
  }

  final phoneRegex = RegExp(r'^[0-9]{10}$'); 
  if (!phoneRegex.hasMatch(value.trim())) {
    return 'Enter a valid 10-digit phone number';
  }

  return null;
}
