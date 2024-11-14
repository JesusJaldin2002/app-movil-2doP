import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        confirmPassword: json["password_confirmation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
      };
}
