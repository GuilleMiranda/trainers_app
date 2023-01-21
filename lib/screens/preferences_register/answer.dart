import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../model/cliente.dart';

class Answer extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(String, dynamic) questionHandler;
  final Cliente client;

  Answer(
      {Key? key,
      required this.question,
      required this.questionHandler,
      required this.client})
      : super(key: key);

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  dynamic _currentValue;
  double _distance = 15.0;

  @override
  Widget build(BuildContext context) {
    _currentValue =
        widget.client.getPreferencia(widget.question['pregunta'])?.valor;

    return Column(
      children: [
        widget.question['buscador'] ? _buildBuscador() : Container(),
        _buildRespuesta(widget.question['respuesta'])
      ],
    );
  }

  Widget _buildBuscador() {
    return Text('buscador');
  }

  Widget _buildRespuesta(Map<String, dynamic> respuesta) {
    var tipo = respuesta['tipo'];
    var slider = respuesta['slider'];
    var rango = slider ? respuesta['rango'] : null;

    List<Map<String, dynamic>> opciones = respuesta['opciones'];

    List<Widget> widgets = [];

    if (rango != null) {
      return Slider(
        label: '${_distance.floor()}km',
        value: _distance,
        min: 5,
        max: 105,
        divisions: 10,
        onChanged: (option) {
          setState(() {
            _distance = option.floorToDouble();
          });
        },
        onChangeEnd: (_) {
          widget.questionHandler(
              widget.question['pregunta'], _distance.floor());
        },
      );
    }

    switch (tipo) {
      case ('RADIO_BUTTON'):
        {
          widgets = opciones.map((response) {
            return ListTile(
              title: Text(response['texto']),
              leading: Radio<int>(
                value: response['id'],
                groupValue: _currentValue,
                onChanged: (id) {
                  setState(() => _currentValue = id);
                  widget.questionHandler(widget.question['pregunta'], id);
                },
              ),
            );
          }).toList();
        }
        break;
      case ('COMBO_BOX'):
        {
          widgets.add(
            DropdownButton(
              hint: Text('Tipo de plan'),
              value: opciones[0]['id'],
              items: opciones
                  .map((opcion) => DropdownMenuItem(
                        value: opcion['id'],
                        child: Text(opcion['texto']),
                      ))
                  .toList(),
              onChanged: (plan) {
                widget.questionHandler('TIPO_PLAN', plan);
              },
            ),
          );

          if (respuesta['slider']) {
            dynamic min = respuesta['rango']['min'];
            dynamic max = respuesta['rango']['max'];

            if (_currentValue < min || _currentValue > max) {
              _currentValue = double.parse(min.toString());
            }

            widgets.add(Slider(
              label: 'PYG ${(_currentValue as double).roundToDouble()}',
              value: (_currentValue as double).roundToDouble(),
              min: double.parse(min.toString()),
              max: double.parse(max.toString()),
              onChanged: (price) {
                setState(() => _currentValue = price);
                widget.questionHandler(widget.question['pregunta'], price);
              },
            ));
          }
        }
    }
    return Column(
      children: widgets,
    );
  }
}
