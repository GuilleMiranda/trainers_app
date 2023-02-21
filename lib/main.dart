import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/chat/chat.dart';
import 'package:trainers_app/screens/messages/messages.dart';
import 'package:trainers_app/screens/preferences_client/preferences.dart';
import 'package:trainers_app/screens/preferences_register/preferences.dart';

import 'package:trainers_app/screens/profile/profile.dart';
import 'package:trainers_app/screens/register/register.dart';
import 'package:trainers_app/screens/trainer_detail/trainer_detail.dart';
import 'package:trainers_app/services/gender.service.dart';
import './screens/auth/auth.dart';
import './screens/favorites/favorites.dart';
import './screens/home_screen/home_screen.dart';

void main() {
  GenderService.getGeneros().then((value) => EnvironmentConstants.genders = value);
  runApp(ChangeNotifierProvider(
    create: (context) => Session(),
    child: const Trainers(),
  ));
}

class Trainers extends StatelessWidget {
  const Trainers({Key? key}) : super(key: key);

  final bool isLogged = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('es', 'ES'),
      debugShowCheckedModeBanner: false,
      title: 'Trainers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Auth(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        Auth.routeName: (context) => Auth(),
        Favorites.routeName: (context) => Favorites(),
        Messages.routeName: (context) => Messages(),
        Profile.routeName: (context) => Profile(),
        Register.routeName: (context) => Register(),
        TrainerDetail.routeName: (context) => TrainerDetail(),
        Chat.routeName: (context) => Chat(
              arguments: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>),
            ),
        PreferencesRegister.routeName: (context) => PreferencesRegister(),
        PreferencesClient.routeName: (context) => PreferencesClient()
      },
    );
  }
}
