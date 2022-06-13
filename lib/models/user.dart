class User {
  final int? id;
  final String? name;
  final String? email;
  final String? image;
  final String? token;

  const User({
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
      token: json['token'],
    );
  }
}
