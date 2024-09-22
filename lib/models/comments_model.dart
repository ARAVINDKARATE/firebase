class Comment {
  final int postId; // The ID of the post this comment belongs to
  final int id; // Unique identifier for the comment
  final String name; // Name of the commenter
  final String email; // Email of the commenter
  final String body; // Content of the comment

  // Constructor for initializing the Comment object
  Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  // Factory method to create a Comment instance from a JSON object
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['postId'], // Extracting postId from JSON
      id: json['id'], // Extracting comment ID from JSON
      name: json['name'], // Extracting name from JSON
      email: json['email'], // Extracting email from JSON
      body: json['body'], // Extracting comment body from JSON
    );
  }
}
