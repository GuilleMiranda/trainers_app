class AuthState {
  final String username;
  final String password;

  AuthState({
    this.username = '',
    this.password = '',
  });

  AuthState copyWith({
    String? username,
    String? password
  }) {
    return AuthState(
        username: username ?? this.username,
        password: password ?? this.password
    );
  }
}