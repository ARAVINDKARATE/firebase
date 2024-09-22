import 'package:firebase_sample_app/models/comments_model.dart';
import 'package:flutter/material.dart';
import '../services/comments_services.dart';

class HomeViewModel extends ChangeNotifier {
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];
  bool _isLoading = false;
  String _error = '';

  /// Provides the list of comments.
  List<Comment> get comments => _comments;

  /// Indicates whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Provides the error message, if any.
  String get error => _error;

  /// Fetches comments from the CommentService.
  ///
  /// Sets the loading state, handles errors, and updates the comments list.
  Future<void> fetchComments() async {
    _isLoading = true; // Set loading state to true
    notifyListeners(); // Notify listeners of the change

    try {
      // Fetch comments from the service
      _comments = await _commentService.fetchComments();
    } catch (e) {
      // Capture any errors during fetch
      _error = e.toString();
    } finally {
      _isLoading = false; // Reset loading state
      notifyListeners(); // Notify listeners of the final state
    }
  }
}
