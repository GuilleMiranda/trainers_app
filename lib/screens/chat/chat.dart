import 'package:flutter/material.dart';
import 'package:trainers_app/model/entrenador.dart';

class Chat extends StatelessWidget {
  static const routeName = '/chat';

  late Entrenador entrenador;

  @override
  Widget build(BuildContext context) {
    entrenador = ModalRoute.of(context)!.settings.arguments as Entrenador;
    return Scaffold(
      appBar: AppBar(
        title: Text(entrenador.nombreMostrado),
      ),
      body: Text('here'),
    );
  }
}
