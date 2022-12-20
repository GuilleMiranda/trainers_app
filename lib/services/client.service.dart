import 'dart:convert';

import 'package:trainers_app/constants/environment.dart';

import 'package:http/http.dart' as http;

class ClientService {
  final uri = '${EnvironmentConstants.apiUrl}cliente/';

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    print('$uri${EnvironmentConstants.get_preguntas}');
    final response =
        await http.get(Uri.parse('$uri${EnvironmentConstants.get_preguntas}'));
    if (response.statusCode == 200) {
      return ((json.decode(response.body) as List)
          .map(
            (question) => {
              "pregunta": question['pregunta'],
              "titulo": question['titulo'],
              "buscador": question['buscador'],
              "respuesta": {
                "tipo": question['respuesta']['tipo'],
                "opciones": [ //TODO generar lista de la respuesta
                  {"id": 0, "texto": "Perder o mantener peso."},
                  {"id": 1, "texto": "Desarrollar la musculatura."},
                  {"id": 2, "texto": "Aprender o mejorar en un deporte."},
                  {"id": 3, "texto": "Llevar una vida saludable."},
                  {"id": 4, "texto": "Recuperarme de una lesión."},
                ],
                "slider": question['respuesta']['slider'],
                "rango": question['respuesta']['rango'],
              },
            },
          ) //TODO crear model
          .toList());
    } else {
      throw Exception('Fallo al recuperar preguntas');
    }
  }
}
