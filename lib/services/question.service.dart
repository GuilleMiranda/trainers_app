import 'dart:convert';

import 'package:trainers_app/constants/environment.dart';

import 'package:http/http.dart' as http;

class QuestionService {
  final uri = '${EnvironmentConstants.apiUrl}pregunta/';

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
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
                "opciones": [
                  ...(question['respuesta']['opciones'] as List).map((opcion) {
                    return {"id": opcion['id'], "texto": opcion['texto']};
                  }).toList()
                ],
                "slider": question['respuesta']['slider'],
                "rango": question['respuesta']['rango'],
              },
            },
          )
          .toList());
    } else {
      throw Exception('Fallo al recuperar preguntas');
    }
  }
}
