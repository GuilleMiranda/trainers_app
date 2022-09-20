import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trainers_app/model/entrenador.dart';

class EntrenadorTile extends StatefulWidget {
  final Entrenador entrenador;

  const EntrenadorTile(this.entrenador, {Key? key}) : super(key: key);

  @override
  State<EntrenadorTile> createState() => _EntrenadorTileState();
}

class _EntrenadorTileState extends State<EntrenadorTile> {
  bool expanded = false;

  void _toggleExpanded(bool currentValue) {
    setState(() {
      expanded = currentValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: _toggleExpanded,
      leading: Icon(
        Icons.account_circle,
        size: 48,
      ),
      title: Text(
        widget.entrenador.nombreMostrado,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      trailing: expanded
          ? Icon(
              Icons.arrow_drop_up_outlined,
              size: 36,
            )
          : Icon(
              Icons.arrow_drop_down_outlined,
              size: 36,
            ),
      subtitle: Row(
        children: [
          Text(
            widget.entrenador.calificacion.toStringAsFixed(1),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ],
      ),
      children: [
        Text('${widget.entrenador.experiencia} años de experiencia'),
      ],
    );
  }
}
