import 'package:firebase_sample_app/pages/login/login.dart';
import 'package:firebase_sample_app/utilities/validation_util.dart';
import 'package:firebase_sample_app/viewmodela/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SignupViewModel _viewModel = SignupViewModel();

  // Variables for error messages and password visibility
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  // Common button style for consistency
  ButtonStyle commonButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF0C54BE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCED3DC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Color(0xFF0C54BE),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 28,
          ),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  _nameField(),
                  const SizedBox(height: 20),
                  _emailAddress(),
                  const SizedBox(height: 20),
                  _password(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.26),
                  _signup(context),
                  const SizedBox(height: 10),
                  _buildLoginRedirect(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Text field for entering name
  Widget _nameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Name',
        fillColor: const Color(0xffF7F7F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        errorText: _nameError,
      ),
      onChanged: (value) {
        setState(() {
          _nameError = value.isEmpty ? 'Name cannot be empty' : null;
        });
      },
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

  // Signup button to trigger the signup process
  Widget _signup(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _nameError = _nameController.text.isEmpty ? 'Name cannot be empty' : null;
          _emailError = validateEmail(_emailController.text);
          _passwordError = validatePassword(_passwordController.text);
        });

        // If validation fails, show a toast message
        if (_nameError != null || _emailError != null || _passwordError != null) {
          Fluttertoast.showToast(
            msg: _nameError ?? _emailError ?? _passwordError!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          // If validation passes, call the signup method in the view model
          await _viewModel.signup(_nameController.text, _emailController.text, _passwordController.text, context);
        }
      },
      style: commonButtonStyle(),
      child: const Text(
        "Sign Up",
        style: TextStyle(color: Color(0xFFF5F9FD), fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
      ),
    );
  }

  // Build the redirect to login page
  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "New here?",
          style: TextStyle(
            color: Color(0xFF303F60),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const Login(),
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
            "Login",
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
