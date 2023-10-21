class User {
  final String? name;
  final String? password;
  final String? token;
  final String? email;

  User({this.name, this.password, this.token, this.email});

  @override
  String toString() {
    return 'User{name: $name, password: $password, token: $token, email: $email}';
  }
}
