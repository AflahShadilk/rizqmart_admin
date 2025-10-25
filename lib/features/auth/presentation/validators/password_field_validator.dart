String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  if (value.length < 5) {
    return 'Password must be at least 5 characters long';
  }
  final pattern =
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$';
  final regex = RegExp(pattern);

  if (!regex.hasMatch(value)) {
    return 'Password must include uppercase, lowercase, number & special character';
  }

  return null;
}
