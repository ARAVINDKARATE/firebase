import 'package:firebase_sample_app/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_sample_app/utilities/validation_util.dart';
import 'package:firebase_sample_app/viewmodela/login_viewmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginViewModel _viewModel = LoginViewModel();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCED3DC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: const Text(
          'Comments',
          style: TextStyle(color: Color(0xFF0C54BE), fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 28),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Spacing for aesthetics
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  _emailAddress(),
                  const SizedBox(height: 20),
                  _password(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.27),
                  _signin(context),
                  const SizedBox(height: 10),
                  _buildSignupRedirect(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Text field for entering email
  Widget _emailAddress() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Email',
        fillColor: const Color(0xffF7F7F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        errorText: _emailError,
      ),
      onChanged: (value) {
        setState(() {
          _emailError = validateEmail(value);
        });
      },
    );
  }

  // Text field for entering password
  Widget _password() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Password',
        fillColor: const Color(0xffF7F7F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        errorText: _passwordError,
      ),
      onChanged: (value) {
        setState(() {
          _passwordError = validatePassword(value);
        });
      },
    );
  }

  // Sign-in button to trigger the login process
  Widget _signin(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _emailError = validateEmail(_emailController.text);
          _passwordError = validatePassword(_passwordController.text);
        });

        // If validation fails, show a toast message
        if (_emailError != null || _passwordError != null) {
          Fluttertoast.showToast(
            msg: _emailError ?? _passwordError!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          // If validation passes, call the login method in the view model
          await _viewModel.login(_emailController.text, _passwordController.text, context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0C54BE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
      ),
      child: const Text(
        "Sign In",
        style: TextStyle(color: Color(0xFFF5F9FD), fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Build the redirect to signup page
  Widget _buildSignupRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(color: Color(0xFF303F60), fontSize: 18, fontWeight: FontWeight.w400),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const Signup(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ));
          },
          child: const Text(
            "Signup",
            style: TextStyle(
              color: Color(0xFF0C54BE),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
