/// Validates an email address.
///
/// Returns a validation error message if the email is invalid,
/// or null if it is valid.
String? validateEmail(String email) {
  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (email.isEmpty) return 'Email cannot be empty';
  if (!regex.hasMatch(email)) return 'Enter a valid email address';
  return null;
}

/// Validates a password.
///
/// Returns a validation error message if the password is invalid,
/// or null if it is valid.
String? validatePassword(String password) {
  if (password.isEmpty) return 'Password cannot be empty';
  if (password.length < 8) return 'Password must be at least 8 characters';
  if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Password must contain at least one uppercase letter';
  if (!RegExp(r'[a-z]').hasMatch(password)) return 'Password must contain at least one lowercase letter';
  if (!RegExp(r'[0-9]').hasMatch(password)) return 'Password must contain at least one number';
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return 'Password must contain at least one special character';
  return null;
}

/// Masks an email address for privacy.
///
/// Returns the masked email, revealing only the first three characters
/// and the domain.
String maskEmail(String email) {
  int atIndex = email.indexOf('@');
  if (atIndex < 3) {
    return email;
  }
  // Mask characters after the 3rd character and before '@'
  return '${email.substring(0, 3)}****${email.substring(atIndex)}';
}
