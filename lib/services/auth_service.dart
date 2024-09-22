import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      Fluttertoast.showToast(msg: 'Signup successful!');
      Navigator.pushReplacementNamed(context, '/home'); // Adjust route name
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(msg: 'Login successful!');
      Navigator.pushReplacementNamed(context, '/home'); // Adjust route name
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(msg: 'Sign out successful!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error signing out: $e');
    }
  }

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
