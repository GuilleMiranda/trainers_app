import 'package:flutter/material.dart';
import 'package:trainers_app/screens/chat/chat.dart';
import 'package:trainers_app/screens/messages/messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trainers_app/screens/profile/profile.dart';
import 'package:trainers_app/screens/register/register.dart';
import 'package:trainers_app/screens/trainer_detail/trainer_detail.dart';
import 'package:trainers_app/services/services.dart';
import './screens/auth/auth.dart';
import './screens/favorites/favorites.dart';
import './screens/home_screen/home_screen.dart';

void main() {
  runApp(const Trainers());
}

class Trainers extends StatelessWidget {
  const Trainers({Key? key}) : super(key: key);

  final bool isLogged = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trainers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
        create: (context) => AuthService(),
        child: Auth(),
      ),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        Auth.routeName: (context) => Auth(),
        Favorites.routeName: (context) => Favorites(),
        Messages.routeName: (context) => Messages(),
        Profile.routeName: (context) => Profile(),
        Register.routeName: (context) => Register(),
        TrainerDetail.routeName: (context) => TrainerDetail(),
        Chat.routeName: (context) => Chat()
      },
    );
  }
}
