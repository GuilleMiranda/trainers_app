import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainers_app/screens/auth/auth_event.dart';
import 'package:trainers_app/screens/auth/auth_state.dart';
import 'package:trainers_app/services/services.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc() : super(AuthState(password: "abc123", username: "abcabc")) {
    on<AuthSubmitted>((event, emit) => {print("we are here!")});
  }
}
