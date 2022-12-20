import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/preferencias_cliente.dart';
import 'package:trainers_app/screens/preferences_register/answer.dart';
import 'package:trainers_app/screens/preferences_register/question.dart';
import 'package:trainers_app/services/services.dart';

class Preferences extends StatefulWidget {
  static const routeName = '/preferences_register';

  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  late Future<List<Map<String, dynamic>>> _questions;
  var _questionIndex = 0;

  late Cliente _cliente;
  PreferenciasCliente _preferenciasCliente = PreferenciasCliente();

  @override
  void initState() {
    super.initState();

    _questions = ClientService().fetchQuestions();
  }

  void _answerQuestion(String question, dynamic response) {
    setState(() {
      _preferenciasCliente.setFromQuestion(question, response);
    });
    print(_cliente.preferenciasCliente.toJson().toString());
  }

  Widget _buildNavigationButtons(String? question, int? length) {
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
            var respuesta =
                _cliente.preferenciasCliente.getFromQuestion(question!);

            if (respuesta == -1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Elegí una opción antes de continuar.'),
                  backgroundColor: Theme.of(context).errorColor,
                  duration: const Duration(milliseconds: 750),
                ),
              );
              return;
            }

            if (_questionIndex < length! - 1) {
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
      body: FutureBuilder(
        future: _questions,
        builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) =>
            snapshot.hasData
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).viewPadding.top + 4,
                        ),
                        Column(
                          children: [
                            Text('Contanos sobre vos',
                                style: Theme.of(context).textTheme.titleLarge),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  'Contestá las siguientes preguntas y nosotros nos encargamos de encontrar al mejor profesional para vos.'),
                            )
                          ],
                        ),
                        Question(
                            questionText: snapshot.data?[_questionIndex]
                                ['titulo']),
                        Answer(
                            question: snapshot.data![_questionIndex],
                            questionHandler: _answerQuestion,
                            preferences: _cliente.preferenciasCliente),
                        _buildNavigationButtons(
                            snapshot.data![_questionIndex]['pregunta'],
                            snapshot.data?.length)
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
//
//
// final List<Map<String, dynamic>> _questions = [
//   {
//     "pregunta": "OBJETIVO",
//     "titulo": "¿Cuál es tu objetivo al entrenar?",
//     "buscador": false,
//     "respuesta": {
//       "tipo": "RADIO_BUTTON",
//       "opciones": [
//         {"id": 0, "texto": "Perder o mantener peso."},
//         {"id": 1, "texto": "Desarrollar la musculatura."},
//         {"id": 2, "texto": "Aprender o mejorar en un deporte."},
//         {"id": 3, "texto": "Llevar una vida saludable."},
//         {"id": 4, "texto": "Recuperarme de una lesión."},
//       ],
//       "slider": false,
//       "rango": null,
//     },
//   },
//   {
//     "pregunta": "DEPORTE",
//     "titulo": "¿Qué actividad deportiva querés hacer?",
//     "buscador": true,
//     "respuesta": {
//       "tipo": "RADIO_BUTTON",
//       "opciones": [
//         {"id": 0, "texto": "Natación"},
//         {"id": 1, "texto": "Gimnasia"},
//         {"id": 2, "texto": "Fútbol"},
//       ],
//       "slider": false,
//       "rango": null,
//     },
//   },
//   {
//     "pregunta": "EXPERIENCIA_DISCIPLINA",
//     "titulo": "¿Ya realizaste esta disciplina antes?",
//     "buscador": false,
//     "respuesta": {
//       "tipo": "RADIO_BUTTON",
//       "opciones": [
//         {"id": 0, "texto": "Nunca."},
//         {"id": 1, "texto": "Por menos de 1 año."},
//         {"id": 2, "texto": "Entre 1 ano y 5 año."},
//       ],
//       "slider": false,
//       "rango": null,
//     },
//   },
//   {
//     "pregunta": "MODALIDAD",
//     "titulo": "¿En qué modaliadad te gustaría entrenar?",
//     "buscador": false,
//     "respuesta": {
//       "tipo": "RADIO_BUTTON",
//       "opciones": [
//         {"id": 0, "texto": "Exclusivamente presencial."},
//         {"id": 1, "texto": "Exclusivamente virtual."},
//         {"id": 2, "texto": "Mixto."},
//         {"id": 2, "texto": "No tengo preferencia."},
//       ],
//       "slider": false,
//       "rango": null,
//     },
//   },
//   {
//     "pregunta": "LOCALIZACION",
//     "titulo": "¿Dónde te gustaría entrenar?",
//     "buscador": false,
//     "respuesta": {
//       "tipo": "RADIO_BUTTON",
//       "opciones": [
//         {"id": 0, "texto": "En un gimnasio."},
//         {"id": 1, "texto": "Al aire libre."},
//         {"id": 2, "texto": "En mi domicilio."},
//         {"id": 3, "texto": "En un club/centro deportivo."},
//         {"id": 4, "texto": "Mixto."},
//         {"id": 5, "texto": "No tengo preferencia."},
//       ],
//       "slider": false,
//       "rango": null,
//     },
//   },
//   {
//     "pregunta": "CONDICION_SALUD",
//     "titulo": "¿Tenés alguna condición especial de salud?",
//     "buscador": false,
//     "respuesta": {
//       "tipo": "RADIO_BUTTON",
//       "opciones": [
//         {"id": 0, "texto": "Sí."},
//         {"id": 1, "texto": "No."},
//       ],
//       "slider": false,
//       "rango": null,
//     },
//   },
// ];
}
