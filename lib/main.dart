import 'package:flutter/material.dart';
import 'package:trainers_app/screens/messages/messages.dart';
import 'package:location/location.dart';

import 'package:trainers_app/screens/profile/profile.dart';
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
      home: isLogged
          ? HomeScreen()
          : Auth(
              key: key,
            ),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        Auth.routeName: (context) => Auth(),
        Favorites.routeName: (context) => Favorites(),
        Messages.routeName: (context) => Messages(),
        Profile.routeName: (context) => Profile(),
      },
    );
  }
}
