import 'package:flutter/material.dart';
import '../home_screen/home_screen.dart';
import '../register/register.dart';

class Auth extends StatelessWidget {
  static const routeName = '/auth';
  const Auth({super.key});

  void register(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(
      Register.routeName,
    );
  }

  void homeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(
      HomeScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Authentication screen'),
            ElevatedButton(
              onPressed: () => homeScreen(context),
              child: Text('Ingresar'),
            ),
            TextButton(
              onPressed: () => register(context),
              child: Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
