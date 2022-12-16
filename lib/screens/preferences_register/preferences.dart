import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/preferencias_cliente.dart';
import 'package:trainers_app/screens/preferences_register/answer.dart';
import 'package:trainers_app/screens/preferences_register/question.dart';

class Preferences extends StatefulWidget {
  static const routeName = '/preferences_register';

  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  var _questionIndex = 0;

  late Cliente _cliente;
  PreferenciasCliente _preferenciasCliente = PreferenciasCliente();

  void _answerQuestion(String question, dynamic response) {
    setState(() {
      _preferenciasCliente.setFromQuestion(question, response);
    });
    print(_preferenciasCliente.toJson().toString());
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) =>
                  Theme.of(context).colorScheme.onSecondaryContainer)),
          onPressed: () {
            if (_questionIndex > 0) {
              setState(() => _questionIndex--);
            }
          },
          child: const Text(
            'Anterior',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_questionIndex < questions.length - 1) {
              setState(() => _questionIndex++);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Done')));
            }
          },
          child: const Text('Siguiente'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _cliente = ModalRoute.of(context)!.settings.arguments as Cliente;
    _cliente.preferenciasCliente = _preferenciasCliente;

    return Scaffold(
      body: Column(
        children: [
          Question(questionText: questions[_questionIndex]['titulo']),
          Answer(
              question: questions[_questionIndex],
              questionHandler: _answerQuestion,
              preferences: _cliente.preferenciasCliente),
          _buildNavigationButtons()
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> questions = [
    {
      "pregunta": "DEPORTE",
      "titulo": "¿Qué actividad deportiva querés hacer?",
      "buscador": true,
      "respuesta": {
        "tipo": "RADIO_BUTTON",
        "opciones": [
          {"id": 0, "texto": "Natación"},
          {"id": 1, "texto": "Gimnasia"},
          {"id": 2, "texto": "Fútbol"},
        ],
        "slider": false,
        "rango": null,
      },
    },
    {
      "pregunta": "EXPERIENCIA_DISCIPLINA",
      "titulo": "¿Ya realizaste esta disciplina antes?",
      "buscador": false,
      "respuesta": {
        "tipo": "RADIO_BUTTON",
        "opciones": [
          {"id": 0, "texto": "Nunca."},
          {"id": 1, "texto": "Por menos de 1 año."},
          {"id": 2, "texto": "Entre 1 ano y 5 año."},
        ],
        "slider": false,
        "rango": null,
      },
    },
    {
      "pregunta": "PRECIO",
      "titulo": "¿Cuánto querés pagar por un entrenador?",
      "buscador": false,
      "respuesta": {
        "tipo": "COMBO_BOX",
        "opciones": [
          {"id": 0, "texto": "Diario"},
          {"id": 1, "texto": "Mensual"}
        ],
        "slider": true,
        "rango": {"min": 30000, "max": 300000},
      },
    }
  ];
}
