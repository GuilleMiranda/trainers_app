import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trainers_app/constants/environment.dart';

class AuthService {
  static String uri = '${EnvironmentConstants.apiUrl}auth/';

  static Future<bool> authClient(String username, String password) async {
    Map data = {'email': username, 'contrasena': password};
    final body = json.encode(data);

    final response = await http.post(
        Uri.parse('$uri${EnvironmentConstants.post_autenticar_cliente}'),
        headers: {"Content-Type": "application/json"},
        body: body);

    if (response.statusCode == 200) {
      return (json.decode(response.body) as Map)['autenticado'];
    } else {
      throw Error();
    }
  }

  static Future<bool> validateEmail(String email) async {
    Map data = {'email': email};

    final body = json.encode(data);

    final response = await http.post(
        Uri.parse('$uri${EnvironmentConstants.post_validar_email}'),
        headers: {"Content-Type": "application/json"},
        body: body);

    if (response.statusCode == 200) {
      return (json.decode(response.body) as Map)['valido'];
    } else {
      throw Error();
    }
  }
}
