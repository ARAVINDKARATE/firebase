import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupViewModel {
  /// Signs up a user with the provided name, email, and password.
  ///
  /// Calls the AuthService's signup method and handles the
  /// context for navigation or error messages.
  Future<void> signup(String name, String email, String password, BuildContext context) async {
    // Call the signup method from AuthService
    await AuthService().signup(
      name: name,
      email: email,
      password: password,
      context: context,
    );
  }
}
