import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/entrenador.dart';

class ClientService {
  static const uri = '${EnvironmentConstants.apiUrl}cliente/';

  static Future<void> postClient(Cliente cliente) async {
    final response = await http.post(
        Uri.parse('$uri${EnvironmentConstants.post_cliente}'),
        headers: EnvironmentConstants.post_headers,
        body: jsonEncode(cliente.toJson()));
    if (response.statusCode != 200) {
      throw Error();
    }
  }

  static Future<Cliente?> getClient(int id) async {
    final response = await http.get(
        Uri.parse('$uri${EnvironmentConstants.get_cliente}/$id'),
        headers: EnvironmentConstants.get_headers);

    if (response.body.isNotEmpty) {
      return Cliente.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<void> putClient(Cliente cliente) async {
    final response = await http.put(
        Uri.parse('$uri${EnvironmentConstants.put_cliente}'),
        headers: EnvironmentConstants.post_headers,
        body: jsonEncode(cliente.toJson()));
    if (response.statusCode != 200) {
      throw Error();
    }
  }

  static Future<bool> deleteFavorite(int? clientId, int? trainerId) async {
    final response = await http.delete(
        Uri.parse(
            '$uri${EnvironmentConstants.delete_favorito}?idCliente=$clientId&idEntrenador=$trainerId'),
        headers: EnvironmentConstants.get_headers);

    if (response.body.isNotEmpty &&
        jsonDecode(response.body)['status'] == 200) {
      return true;
    }
    throw Error();
  }

  static Future<List<Entrenador>> getFavorites(int id) async {
    final response = await http.get(
        Uri.parse('$uri${EnvironmentConstants.get_favoritos}/$id'),
        headers: EnvironmentConstants.get_headers);

    if (response.body.isNotEmpty) {
      return (jsonDecode(response.body) as List)
          .map((e) => Entrenador.fromJson(jsonDecode(e)))
          .toList();
    }
    return <Entrenador>[];
  }

  static Future<Entrenador> postFavorite(
      Entrenador trainer, int? clientId) async {
    final response = await http.post(
        Uri.parse('$uri${EnvironmentConstants.post_favorito}'),
        body: jsonEncode({"idCliente": clientId, "idEntrenador": trainer.id}),
        headers: EnvironmentConstants.get_headers);

    if (response.body.isNotEmpty) {
      return Entrenador.fromJson(jsonDecode(response.body));
    }

    throw Error();
  }
}
