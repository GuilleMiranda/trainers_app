import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/services/image.service.dart';

import '../trainer_detail/trainer_detail.dart';
import '../../model/Image.dart' as Imagen;

class TrainerTile extends StatefulWidget {
  final Entrenador entrenador;

  const TrainerTile(this.entrenador, {Key? key}) : super(key: key);

  @override
  State<TrainerTile> createState() => _TrainerTileState();
}

class _TrainerTileState extends State<TrainerTile> {
  late Imagen.Image image = Imagen.Image.newImage();

  @override
  Widget build(BuildContext context) {
    image.userId = widget.entrenador.id;
    image.imageType = 'FOTO_PERFIL';
    image.userType = 'ENTRENADOR';

    return ExpansionTile(
      leading: SizedBox(
          width: 52,
          child: FutureBuilder(
            future: ImageService.getImage(image),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return CircleAvatar(
                  maxRadius: 100,
                  child: ClipOval(
                    child: Image.memory(base64Decode((snapshot.data as Imagen.Image).base64)),
                  ),
                );
              }

              return CircleAvatar(
                radius: 52,
                child: Text(
                    '${widget.entrenador.nombres[0]}${widget.entrenador.apellidos[0]}'),
              );
            },
          )),
      title: Text(
        widget.entrenador.nombreMostrado.titleCase,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Row(
        children: [
          Text(
            widget.entrenador.calificacion.toStringAsFixed(1),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ],
      ),
      children: [
        Text('${widget.entrenador.experiencia} años de experiencia'),
        TextButton(onPressed: _detalleEntrenador, child: const Text("Ver más")),
      ],
    );
  }

  _detalleEntrenador() {
    Navigator.of(context)
        .pushNamed(TrainerDetail.routeName, arguments: widget.entrenador);
  }
}
