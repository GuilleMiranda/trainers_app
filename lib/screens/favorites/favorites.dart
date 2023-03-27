import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/trainer_detail/trainer_detail.dart';
import 'package:trainers_app/services/client.service.dart';

import '../../services/image.service.dart';
import '../../model/Image.dart' as Imagen;

class Favorites extends StatefulWidget {
  static const routeName = '/favorites';

  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favoritos'),
        ),
        body: Consumer<Session>(
          builder: (context, session, child) {
            if (session.favoriteTrainers.isEmpty) {
              return const Center(
                child: Text('Todavía no tenés favoritos.'),
              );
            }
            return _buildFavoriteList(session.favoriteTrainers);
          },
        ));
  }

  Widget _buildFavoriteList(Set<Entrenador> trainers) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: trainers.length,
        itemBuilder: (context, index) {
          Imagen.Image image = Imagen.Image.newImage();
          image.userId = trainers.elementAt(index).id;
          image.imageType = 'FOTO_PERFIL';
          image.userType = 'ENTRENADOR';
          return ListTile(
            leading: SizedBox(
              width: 52,
              child: FutureBuilder(
                future: ImageService.getImage(image),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return CircleAvatar(
                      maxRadius: 100,
                      child: ClipOval(
                        child: Image.memory(base64Decode(
                            (snapshot.data as Imagen.Image).base64)),
                      ),
                    );
                  }

                  return CircleAvatar(
                    radius: 52,
                    child: Text(
                        '${trainers.elementAt(index).nombres[0]}${trainers.elementAt(index).apellidos[0]}'),
                  );
                },
              ),
            ),
            title: Text(
              trainers.elementAt(index).nombreMostrado.titleCase,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                int? clientId =
                    Provider.of<Session>(context, listen: false).client?.id;

                ClientService.deleteFavorite(
                        clientId, trainers.elementAt(index).id)
                    .then((ok) => ok
                        ? setState(
                            () => trainers.remove(trainers.elementAt(index)))
                        : null);
              },
            ),
            onTap: () => Navigator.of(context).pushReplacementNamed(
                TrainerDetail.routeName,
                arguments: trainers.elementAt(index)),
          );
        });
  }
}
