import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
