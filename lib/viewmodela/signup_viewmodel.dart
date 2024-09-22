import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupViewModel {
  Future<void> signup(String name, String email, String password, BuildContext context) async {
    await AuthService().signup(
      name: name,
      email: email,
      password: password,
      context: context,
    );
  }
}
