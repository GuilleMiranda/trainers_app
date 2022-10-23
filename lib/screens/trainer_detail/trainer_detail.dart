import 'package:flutter/material.dart';
import 'package:trainers_app/model/entrenador.dart';

class TrainerDetail extends StatelessWidget {
  static const routeName = '/trainerdetail';

  late Entrenador entrenador;

  @override
  Widget build(BuildContext context) {
    entrenador = ModalRoute.of(context)!.settings.arguments as Entrenador;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          entrenador.nombreMostrado,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              ColoredBox(
                color: Colors.pink,
                child: Container(
                  height: 240,
                  width: double.infinity,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  entrenador.nombreMostrado,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(entrenador.descripcion),
              ConstrainedBox(constraints: BoxConstraints.tight(Size(10, 10))),

            ],
          ),
        ),
      ),
    );
  }
}
