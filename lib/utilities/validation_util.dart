String? validateEmail(String email) {
  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (email.isEmpty) return 'Email cannot be empty';
  if (!regex.hasMatch(email)) return 'Enter a valid email address';
  return null;
}

String? validatePassword(String password) {
  if (password.isEmpty) return 'Password cannot be empty';
  if (password.length < 8) return 'Password must be at least 8 characters';
  if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Password must contain at least one uppercase letter';
  if (!RegExp(r'[a-z]').hasMatch(password)) return 'Password must contain at least one lowercase letter';
  if (!RegExp(r'[0-9]').hasMatch(password)) return 'Password must contain at least one number';
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return 'Password must contain at least one special character';
  return null;
}
