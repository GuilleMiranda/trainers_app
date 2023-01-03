import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/match.dart';

class MatchService {
  static const uri = '${EnvironmentConstants.apiUrl}match/';

  static Future<Map<String, dynamic>> postMatch(Match match) async {

    final response = await http.post(
        Uri.parse('$uri${EnvironmentConstants.post_match}'),
        headers: EnvironmentConstants.post_headers,
        body: jsonEncode(match.toJson()));

    if (response.statusCode == 200 && response.body.isEmpty) {
      return {
        "message": 'Ya hicieron match!',
        "isMatch": false
      };
    }

    if (response.statusCode != 200) {
      throw Error();
    }

    return {
      "message": 'Encontraste a tu entrenador!',
      "isMatch": true
    };
  }
}
