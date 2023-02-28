import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/entrenador.dart';

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

  Future<List<Map<String, dynamic>>> fetchTrainerParams(id) async {
    final response = await http.get(
        Uri.parse('$uri${EnvironmentConstants.get_entrenador}/$id/parametros'),
        headers: EnvironmentConstants.get_headers);
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => {
                'parametro': e['parametro'],
                'valorParametro': e['valorParametro']
              })
          .toList();
    } else {
      throw Exception('Error al recuperar parámetros del entrenador');
    }
  }

  Future<List<Entrenador>> fetchCandidates(id, lat, lon) async {
    String uriWithParams;
    if (lat == null || lon == null) {
      uriWithParams = '$uri${EnvironmentConstants.get_candidatos}?id=$id';
    } else {
      uriWithParams =
          '$uri${EnvironmentConstants.get_candidatos}?id=$id&lat=$lat&lon=$lon';
    }
    final response = await http.get(Uri.parse(uriWithParams),
        headers: EnvironmentConstants.get_headers);

    if (response.body.isNotEmpty && response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => Entrenador.fromJson(e))
          .toList();
    } else {
      throw Exception('Fallo al recuperar candidatos');
    }
  }
}
