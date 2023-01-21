import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/match.dart';

class MatchService {
  static const uri = '${EnvironmentConstants.apiUrl}match/';

  static Future<List<Entrenador>> getClientMatches(int clientId) async {
    final response = await http.get(
        Uri.parse('$uri${EnvironmentConstants.get_matches_cliente}/$clientId'),
        headers: EnvironmentConstants.get_headers);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return (json.decode(response.body) as List)
          .map((trainers) => Entrenador.fromJson(trainers))
          .toList();
    }

    return <Entrenador>[];
  }

  static Future<Map<String, dynamic>> postMatch(Match match) async {
    final response = await http.post(
        Uri.parse('$uri${EnvironmentConstants.post_match}'),
        headers: EnvironmentConstants.post_headers,
        body: jsonEncode(match.toJson()));

    if (response.statusCode == 200 && response.body.isEmpty) {
      return {'message': 'Ya hicieron match antes', 'isMatch': false};
    }

    if (response.statusCode != 200) {
      throw Error();
    }

    return {'message': '¡Encontraste a tu entrenador!', 'isMatch': true};
  }

  static Future<Map<String, dynamic>> postUnmatch(Match match) async {
    final response = await http.post(
        Uri.parse('$uri${EnvironmentConstants.post_unmatch}'),
        headers: EnvironmentConstants.post_headers,
        body: jsonEncode(match.toJson()));

    if (response.statusCode == 200 && response.body.isEmpty) {
      return {'message': '', 'isUnmatch': false};
    }

    if (response.statusCode != 200) {
      throw Error();
    }

    return {'message': '¡Listo!', 'isNotMatch': true};
  }
}
