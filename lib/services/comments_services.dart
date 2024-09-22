import 'dart:convert';
import 'package:firebase_sample_app/models/comments_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CommentService {
  final String url = "https://jsonplaceholder.typicode.com/comments";

  Future<List<Comment>> fetchComments() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      Fluttertoast.showToast(msg: 'Failed to load comments');
      throw Exception("Failed to load comments");
    }
  }
}
