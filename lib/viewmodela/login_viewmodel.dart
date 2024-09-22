import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel {
  final AuthService _authService = AuthService();

  Future<void> login(String email, String password, BuildContext context) async {
    await _authService.signin(
      email: email,
      password: password,
      context: context,
    );
  }
}
