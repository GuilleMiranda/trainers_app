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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Preferencias'),
        ),
        body: Consumer<Session>(builder: (context, session, child) {
          client = Cliente.copyOf(session.client!);
          return Container(
            padding: EdgeInsets.all(8.0),
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

    for (var preference in preferenceTypes) {
      preferences.add(_buildTile(preference));
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
      default:
        return preference.headerCase;
    }
  }
}
