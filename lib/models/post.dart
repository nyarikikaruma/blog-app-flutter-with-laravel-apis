import 'package:blogapp/models/user.dart';
import 'package:file_picker/file_picker.dart';

class Post {
  int? id;
  String? body;
  String? image;
  int? likesCount;
  int? commentsCount;
  User? user;
  bool? selfLiked;

  Post(
      {this.body,
      this.commentsCount,
      this.id,
      this.image,
      this.likesCount,
      this.selfLiked,
      this.user});

  // Map json to post model

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      body: json['body'],
      id: json['id'],
      commentsCount: json['comments_count'],
      image: json['image'],
      likesCount: json['liked_count'],
      selfLiked: json['likes'],
      user: User(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
      ),
    );
  }
}
