String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regex = RegExp(pattern);

  if (!regex.hasMatch(value.trim())) {
    return 'Enter a valid email address';
  }

  return null;
}
