import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/gender.dart';

class GenderService {
  static const uri = '${EnvironmentConstants.apiUrl}genero/';

  static Future<List<Gender>> getGeneros() async {
    final response = await http.get(
        Uri.parse('$uri${EnvironmentConstants.get_generos}'),
        headers: EnvironmentConstants.get_headers);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return (json.decode(response.body) as List)
          .map((genders) => Gender.fromJson(genders))
          .toList();
    }

    return <Gender>[];
  }
}
