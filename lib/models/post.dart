import 'package:blogapp/models/user.dart';

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
}
