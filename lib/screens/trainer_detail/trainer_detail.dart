import 'package:flutter/material.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/screens/chat/chat.dart';
import 'package:trainers_app/screens/favorites/favorites.dart';

class TrainerDetail extends StatelessWidget {
  static const routeName = '/trainerdetail';

  late Entrenador entrenador;

  void _assignTrainer(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('¡Encontraste a tu entrenador!'),
      ),
    );

    Navigator.of(context)
        .pushReplacementNamed(Chat.routeName, arguments: entrenador);
  }

  void _addFavorite(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Agregaste a ${entrenador.nombreMostrado} a tu lista'),
      ),
    );
    Navigator.of(context).pushReplacementNamed(Favorites.routeName);
  }

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
                color: Colors.blue,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _addFavorite(context),
                    child: Row(
                      children: [
                        Icon(Icons.favorite),
                        Text('A favoritos'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _assignTrainer(context),
                    child: Row(
                      children: [
                        Icon(Icons.handshake),
                        Text('¡Entrenar!'),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
