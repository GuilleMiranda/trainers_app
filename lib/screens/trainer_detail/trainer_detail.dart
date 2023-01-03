import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/match.dart';
import 'package:trainers_app/screens/chat/chat.dart';
import 'package:trainers_app/screens/favorites/favorites.dart';
import 'package:trainers_app/services/match.service.dart';

import '../../model/session.dart';

class TrainerDetail extends StatelessWidget {
  static const routeName = '/trainerdetail';

  late Entrenador entrenador;

  void _assignTrainer(BuildContext context) {
    Cliente? client = Provider.of<Session>(context, listen: false).client;

    Match match = Match(client!.id, entrenador.id);

    MatchService.postMatch(match).then((value) {
      Color color;
      if (value['isMatch']) {
        color = Colors.green;

        Provider.of<Session>(context, listen: false)
            .setMatchTrainer(entrenador);
      } else {
        color = Colors.orange;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Text(value['message']),
        ),
      );

      Navigator.of(context)
          .pushReplacementNamed(Chat.routeName, arguments: entrenador);
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Algo salió mal'),
        ),
      );
    });
  }

  void _addFavorite(BuildContext context) {
    Provider.of<Session>(context, listen: false)
        .favoriteTrainers
        .add(entrenador);

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
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const ColoredBox(
                color: Colors.blue,
                child: SizedBox(
                  height: 240,
                  width: double.infinity,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
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
              ConstrainedBox(
                  constraints: BoxConstraints.tight(const Size(10, 10))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _addFavorite(context),
                    child: Row(
                      children: const [
                        Icon(Icons.favorite),
                        Text('A favoritos'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _assignTrainer(context),
                    child: Row(
                      children: const [
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
