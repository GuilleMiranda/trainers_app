import 'dart:convert';

import 'package:trainers_app/constants/environment.dart';

import 'package:http/http.dart' as http;
import 'package:trainers_app/model/cliente.dart';

class ClientService {
  static const uri = '${EnvironmentConstants.apiUrl}cliente/';

  static Future<void> postClient(Cliente cliente) async {
    final response =
        await http.post(Uri.parse('$uri${EnvironmentConstants.post_cliente}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(cliente.toJson()));
    if (response.statusCode != 200) {
      print(response.body);
    }
  }
}
