import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/preferencia_cliente.dart';
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

  @override
  void initState() {
    super.initState();

    _questions = QuestionService().fetchQuestions();
  }

  void _answerQuestion(String question, dynamic response) {
    setState(() {
      _cliente.setPreferencia(question, response);
    });
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
            var respuesta = _cliente.getPreferencia(question!)?.valor;

            if (respuesta == null || respuesta == -1) {
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
              ClientService.postClient(_cliente).then((value) => null);
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
                            client: _cliente),
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
}
