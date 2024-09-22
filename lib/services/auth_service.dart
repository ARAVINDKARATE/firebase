import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Signs up a new user with the provided name, email, and password.
  ///
  /// Stores user information in Firestore upon successful signup
  /// and navigates to the home screen.
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Store user details in Firestore
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      Fluttertoast.showToast(msg: 'Signup successful!');
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  /// Signs in an existing user with the provided email and password.
  ///
  /// Navigates to the home screen upon successful login.
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in the user
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(msg: 'Login successful!');
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(msg: 'Sign out successful!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error signing out: $e');
    }
  }

  /// Handles Firebase authentication errors and displays appropriate messages.
  void _handleAuthError(FirebaseAuthException e) {
    String message = '';
    switch (e.code) {
      case 'weak-password':
        message = 'The password provided is too weak.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with that email.';
        break;
      case 'invalid-email':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided for that user.';
        break;
      default:
        message = e.code;
    }
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
  }
}
