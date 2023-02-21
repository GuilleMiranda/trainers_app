import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/home_screen/home_screen.dart';
import 'package:trainers_app/services/services.dart';

import '../../model/cliente.dart';

class PreferencesClient extends StatefulWidget {
  static const routeName = '/preferences_client';

  const PreferencesClient({super.key});

  @override
  State<PreferencesClient> createState() => _PreferencesClientState();
}

class _PreferencesClientState extends State<PreferencesClient> {
  late Future<List<Map<String, dynamic>>> _futurePreferences;
  late Cliente client;
  late int clientOptionId;

  @override
  void initState() {
    _futurePreferences = QuestionService().fetchPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const
          Text('Preferencias'),
        ),
        body: Consumer<Session>(builder: (context, session, child) {
          client = Cliente.copyOf(session.client!);
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _futurePreferences,
              builder: ((context, snapshot) => snapshot.hasData
                  ? SingleChildScrollView(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          _buildPreference(context, snapshot.data),
                          ElevatedButton(
                              onPressed: () {
                                session.setClient(client);
                                ClientService.putClient(session.client!)
                                    .then((value) {
                                  Navigator.of(context).pushReplacementNamed(
                                      HomeScreen.routeName);
                                });
                              },
                              child: const Text('Guardar')),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator())),
            ),
          );
        }));
  }

  Widget _buildPreference(BuildContext context, dynamic preferenceTypes) {
    List<Widget> preferences = [];
    String distanceLabel;

    for (var preference in preferenceTypes) {
      if (preference['preferencia'] == 'DISTANCIA') {
        clientOptionId =
            client.getPreferencia(preference['preferencia'])!.valor;
        double doubleOption = clientOptionId.toDouble();
        distanceLabel = clientOptionId.toString();

        preferences.add(Column(
          children: [
            Text(
              _preferenceLabel(preference['preferencia']),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Row(
              children: [
                Text('${distanceLabel}km'),
                Expanded(
                  child: Slider(
                    value: doubleOption,
                    min: 5,
                    max: 100,
                    divisions: 10,
                    label: distanceLabel,
                    onChanged: (option) {
                      setState(() {
                        clientOptionId = option.round();
                        distanceLabel = clientOptionId.toString();
                        client.setPreferencia(preference['preferencia'],
                            int.parse(clientOptionId.toString()));
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
      } else {
        preferences.add(_buildTile(preference));
      }
    }

    return Column(
      children: preferences,
    );
  }

  Widget _buildTile(dynamic preference) { 
    List<DropdownMenuItem<int>> items = [];
    for (dynamic option in preference['opciones']) {
      items.add(
        DropdownMenuItem(
          value: option['id'],
          child: Text(option['texto']),
        ),
      );
    }

    clientOptionId = client.getPreferencia(preference['preferencia'])!.valor;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _preferenceLabel(preference['preferencia']),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          DropdownButtonFormField(
            value: clientOptionId,
            items: items,
            onChanged: (option) {
              setState(() => client.setPreferencia(
                  preference['preferencia'], int.parse(option.toString())));
            },
          ),
        ],
      ),
    );
  }

  String _preferenceLabel(String preference) {
    switch (preference) {
      case 'DEPORTE':
        return 'Actividad deportiva';
      case 'OBJETIVO':
        return 'Objetivo';
      case 'EXPERIENCIA_DISCIPLINA':
        return 'Experiencia';
      case 'MODALIDAD':
        return 'Modalidad';
      case 'LOCALIZACION':
        return 'Lugar';
      case 'CONDICION_SALUD':
        return '¿Alguna condición de salud?';
      case 'HORARIO':
        return '¿Horario?';
      case 'SEXO_ENTRENADOR':
        return 'Preferís que tu entrenador sea';
      case 'DISTANCIA':
        return '¿Qué tan lejos (km) puede estar tu entrenador?';
      default:
        return preference.headerCase;
    }
  }
}
