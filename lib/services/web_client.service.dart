import 'dart:convert';

import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/entrenador.dart';

import 'package:http/http.dart' as http;

class WebClient {
  Future<List<Entrenador>> fetchTrainers() async {
    final response = await http.get(Uri.parse(
        '${EnvironmentConstants.apiUrl}entrenador/${EnvironmentConstants.get_entrenadores}'));
    // final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => Entrenador.fromJson(e))
          .toList();
    } else {
      throw Exception('Fallo al recuperar entrenadores');
    }
  }
}
