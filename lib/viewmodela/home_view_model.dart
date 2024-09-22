// viewmodels/home_view_model.dart
import 'package:firebase_sample_app/services/comments_services.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];
  bool _isLoading = false;
  String _error = '';

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchComments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _comments = await _commentService.fetchComments();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
