import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel {
  final AuthService _authService = AuthService();

  /// Logs in a user with the provided email and password.
  ///
  /// Calls the signin method from AuthService and passes the context
  /// for navigation or error handling.
  Future<void> login(String email, String password, BuildContext context) async {
    // Invoke the signin method from AuthService
    await _authService.signin(
      email: email,
      password: password,
      context: context,
    );
  }
}
