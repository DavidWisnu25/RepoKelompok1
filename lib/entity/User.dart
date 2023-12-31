import 'dart:convert';

class LoginModel {
  final dynamic status;
  final String message;
  final Map<String, dynamic>? data;

   LoginModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}

class User {
  int id;
  String username;
  String email;
  String password;
  String noHp;
  String gender;
  dynamic data;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.password,
      required this.noHp,
      required this.gender,
      this.data});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        noHp: json["noHp"],
        gender: json["gender"],
        data: json["data"] != null ? Map<String, dynamic>.from(json["data"]) : null,
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "noHp": noHp,
        "gender": gender,
        "data": data,
      };
}
