import '../model/user.dart';

class FailedRegister implements Exception {
  String errorMessage() {
    return "Register Failed";
  }
}

class RegisterRepository {
  static List<User> data = [];

  Future<User> register(String username, String email, String password) async {
    await Future.delayed(const Duration(seconds: 3), () {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        if (isEmailUnique(email)) {
          User userData = User(
            name: username,
            email: email,
            password: password,
            token: "12345",
          );
          data.add(userData);
          return userData;
        } else {
          throw 'Email is already registered';
        }
      } else if (username == '' || email == '' || password == '') {
        throw 'Username, email, or password cannot be empty';
      } else {
        throw FailedRegister();
      }
    });

    // Dummy return statement, this can be modified based on your needs
    return User(name: '', email: '', password: '', token: '');
  }

  bool isEmailUnique(String email) {
    return !data.any((user) => user.email == email);
  }
}