class User {
  String? id;
  String? name;
  String? email;
  String? image;
  String? token;

  User({
    this.email,
    this.id,
    this.image,
    this.name,
    this.token,
  });

  /// Convert json data to user model data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        image: json['user']['image'],
        name: json['user']['name'],
        email: json['user']['email'],
        token: json['token']);
  }
}
