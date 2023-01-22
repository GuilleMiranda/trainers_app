import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/match.dart';
import 'package:trainers_app/screens/chat/chat.dart';
import 'package:trainers_app/screens/favorites/favorites.dart';
import 'package:trainers_app/services/client.service.dart';
import 'package:trainers_app/services/match.service.dart';

import '../../model/session.dart';

class TrainerDetail extends StatelessWidget {
  static const routeName = '/trainerdetail';

  late Entrenador trainer;

  void _assignTrainer(BuildContext context) {
    if (!Provider.of<Session>(context, listen: false)
        .matchTrainers
        .contains(trainer)) {
      Cliente? client = Provider.of<Session>(context, listen: false).client;

      Match match = Match(client!.id, trainer.id);

      MatchService.postMatch(match).then((value) {
        Color color;
        if (value['isMatch']) {
          color = Colors.green;
        } else {
          color = Colors.orange;
        }

        Provider.of<Session>(context, listen: false).setMatchTrainer(trainer);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: color,
            content: Text(value['message']),
          ),
        );

        Navigator.of(context)
            .pushReplacementNamed(Chat.routeName, arguments: trainer);
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Algo salió mal'),
          ),
        );
      });
    } else {
      Navigator.of(context)
          .pushReplacementNamed(Chat.routeName, arguments: trainer);
    }
  }

  void _addFavorite(BuildContext context) {
    if (!Provider.of<Session>(context, listen: false)
        .favoriteTrainers
        .contains(trainer)) {
      int? clientId = Provider.of<Session>(context, listen: false).client?.id;
      ClientService.postFavorite(trainer, clientId).then((_) {
        Provider.of<Session>(context, listen: false)
            .setFavoriteTrainer(trainer);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
                'Agregaste a ${trainer.nombreMostrado.titleCase} a tu lista.'),
          ),
        );
        Navigator.of(context).pushReplacementNamed(Favorites.routeName);
      });
    } else {
      Navigator.of(context).pushReplacementNamed(Favorites.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    trainer = ModalRoute.of(context)!.settings.arguments as Entrenador;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          trainer.nombreMostrado,
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
                  trainer.nombreMostrado,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(trainer.descripcion),
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
