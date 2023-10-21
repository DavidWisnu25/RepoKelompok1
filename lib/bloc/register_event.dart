abstract class RegisterEvent {}

class IsPasswordVisibleChanged extends RegisterEvent {}

class NoTelponChanged extends RegisterEvent {
  final int noTelpon;

  NoTelponChanged(this.noTelpon);
}

class SelectedDateChanged extends RegisterEvent {
  final DateTime selectedDate;

  SelectedDateChanged(this.selectedDate);
}

class FormSubmitted extends RegisterEvent {
  String username;
  String email;
  String password;
  String gender;
  int noTelpon;
  DateTime selectedDate;

  FormSubmitted(
      {required this.username,
      required this.email,
      required this.password,
      required this.gender,
      required this.noTelpon,
      required this.selectedDate});
}