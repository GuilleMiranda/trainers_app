abstract class AuthEvent {}

class AuthUsernameChanged extends AuthEvent {
  final String? username;

  AuthUsernameChanged({this.username});
}

class AuthPasswordChanged extends AuthEvent {
  final String? password;

  AuthPasswordChanged({this.password});
}

class AuthSubmitted extends AuthEvent {}
