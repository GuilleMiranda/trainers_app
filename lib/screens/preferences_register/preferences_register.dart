import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/screens/preferences_register/preferences.dart';

class Preferences extends StatefulWidget {
  static const routeName = '/preferences_register';

  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  int _questionIndex = 0;
  late Cliente cliente;

  final questions = const {
    "titulo": "¿Qué actividad deportiva querés hacer?",
    "opciones": [
      {"id": 0, "texto": "Natación"},
      {"id": 1, "texto": "Gimnasia"},
      {"id": 2, "texto": "Fútbol"},
    ],
  };

  Widget buildNavigationButtons() {
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
            if (_questionIndex < 3) {
              setState(() => _questionIndex++);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Done')));
            }
          },
          child:
          const Text('Siguiente'),
        ),
      ],
    );
  }

  Widget buildQuestions() {
    List<Widget> pages = [
      Column(
        children: const [
          Preferences(),
        ],
      ),
      Column(
        children: [
          Container(child: Text('B')),
        ],
      ),
      Column(
        children: [
          Container(child: Text('C')),
        ],
      ),
      Column(
        children: [
          Container(child: Text('D')),
        ],
      ),
    ];
    return pages[_questionIndex];
  }

  @override
  Widget build(BuildContext context) {
    cliente = ModalRoute.of(context)!.settings.arguments as Cliente;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            Column(
              children: [
                Text('Contanos sobre vos',
                    style: Theme.of(context).textTheme.titleLarge),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Contestá las siguientes preguntas y nosotros nos encargamos de encontrar al mejor profesional para vos.'),
                )
              ],
            ),
            Expanded(
              child: buildQuestions(),
            ),
            buildNavigationButtons(),
          ],
        ),
      ),
    );
  }
}
