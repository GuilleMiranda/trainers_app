import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/match.dart';
import 'package:trainers_app/screens/chat/chat.dart';
import 'package:trainers_app/screens/favorites/favorites.dart';
import 'package:trainers_app/services/client.service.dart';
import 'package:trainers_app/services/image.service.dart';
import 'package:trainers_app/services/match.service.dart';
import 'package:trainers_app/services/services.dart';

import '../../constants/environment.dart';
import '../../model/gender.dart';
import '../../model/session.dart';
import '../../model/Image.dart' as Imagen;

class TrainerDetail extends StatelessWidget {
  static const routeName = '/trainerdetail';

  late Entrenador trainer;

  void _assignTrainer(BuildContext context) {
    Cliente? client = Provider
        .of<Session>(context, listen: false)
        .client;

    if (!Provider
        .of<Session>(context, listen: false)
        .matchTrainers
        .contains(trainer)) {
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

        Navigator.of(context).pushReplacementNamed(Chat.routeName,
            arguments: {...trainer.toJson(), 'clientId': client.id});
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Algo salió mal'),
          ),
        );
      });
    } else {
      Navigator.of(context).pushReplacementNamed(Chat.routeName,
          arguments: {...trainer.toJson(), 'clientId': client?.id});
    }
  }

  void _addFavorite(BuildContext context) {
    if (!Provider
        .of<Session>(context, listen: false)
        .favoriteTrainers
        .contains(trainer)) {
      int? clientId = Provider
          .of<Session>(context, listen: false)
          .client
          ?.id;
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

  Widget _buildParameters(parameters) {
    return Column(
      children: (parameters as List)
          .map((p) =>
          Row(
            children: [
              Text(
                '${EnvironmentConstants.paramProfileText[p["parametro"]]}:'
                    .sentenceCase +
                    ' ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${p["textoParametro"]}')
            ],
          ))
          .toList(),
    );
  }

  Widget _buildBody(BuildContext context) {
    Future<List<Map<String, dynamic>>> parameters =
    TrainerService().fetchTrainerParams(trainer.id);
    late Imagen.Image image = Imagen.Image.newImage();
    image.userId = trainer.id;
    image.imageType = 'FOTO_PERFIL';
    image.userType = 'ENTRENADOR';
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            FutureBuilder(future: ImageService.getImage(image),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return CircleAvatar(
                      radius: (MediaQuery
                          .of(context)
                          .size
                          .width * 0.60) / 2,
                      child: ClipOval(
                        child: Image.memory(base64Decode((snapshot
                            .data as Imagen.Image).base64)),
                      ),
                    );
                  }
                  return CircleAvatar(
                    radius: (MediaQuery
                        .of(context)
                        .size
                        .width * 0.60) / 2,
                    child: Text('${trainer.nombres[0]}${trainer.apellidos[0]}',
                        style: const TextStyle(fontSize: 48)),
                  );
                }),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                trainer.nombreMostrado.titleCase,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              trainer.descripcion.sentenceCase,
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(
              thickness: 1,
            ),
            Row(
              children: [
                Text('Género: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(EnvironmentConstants.genders
                    .firstWhere((element) => element.genderId == trainer.genero,
                    orElse: () => const Gender(10, 'Desconocido', 'Genero'))
                    .text
                    .sentenceCase)
              ],
            ),
            FutureBuilder(
                future: parameters,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? _buildParameters(snapshot.data)
                      : const Center(child: CircularProgressIndicator());
                }),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    trainer = ModalRoute
        .of(context)!
        .settings
        .arguments as Entrenador;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            trainer.nombreMostrado,
          ),
        ),
        body: _buildBody(context));
  }
}
