abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String username;
  final Uri? avatar;

  RegisterSubmitted({required this.email, required this.password, required this.username , this.avatar});
}
