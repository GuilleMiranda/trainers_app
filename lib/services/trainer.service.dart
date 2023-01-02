import 'dart:convert';

import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/entrenador.dart';

import 'package:http/http.dart' as http;

class TrainerService {
  final uri = '${EnvironmentConstants.apiUrl}entrenador/';

  Future<List<Entrenador>> fetchTrainers() async {
    final response = await http.get(
        Uri.parse('$uri${EnvironmentConstants.get_entrenadores}'),
        headers: EnvironmentConstants.get_headers);

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => Entrenador.fromJson(e))
          .toList();
    } else {
      throw Exception('Fallo al recuperar entrenadores');
    }
  }

  Future<List<Entrenador>> fetchCandidates() async {
    final response = await http.get(
        Uri.parse('$uri${EnvironmentConstants.get_candidatos}'),
        headers: EnvironmentConstants.get_headers);

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => Entrenador.fromJson(e))
          .toList();
    } else {
      throw Exception('Fallo al recuperar candidatos');
    }
  }
}
