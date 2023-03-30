import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trainers_app/constants/environment.dart';

import '../model/Image.dart';

class ImageService {
  static const uri = '${EnvironmentConstants.apiUrl}imagen/';

  static Future<Image> getImage(Image image) async {
    final response = await http.get(
        Uri.parse(
            '$uri${EnvironmentConstants.get_imagen}?idPersona=${image.userId}&tipoPersona=${image.userType}&tipoImagen=${image.imageType}'),
        headers: EnvironmentConstants.get_headers);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Image.fromJson(jsonDecode(response.body));
    }

    throw Error();
  }

  static Future<void> postImage(Image image) async {
    final response = await http.post(
        Uri.parse('$uri${EnvironmentConstants.post_imagen}'),
        body: jsonEncode(image.toJson()),
        headers: EnvironmentConstants.get_headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Error();
    }
  }
}
