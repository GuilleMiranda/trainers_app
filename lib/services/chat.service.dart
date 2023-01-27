import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/message.dart';

class ChatService {
  final uri = '${EnvironmentConstants.apiUrl}chat/';

  Future<List<Message>> fetchMessages(
      String senderId, String recipientId) async {
    final response =
        await http.get(Uri.parse('$uri${EnvironmentConstants.get_mensajes}'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((message) => Message.fromJson(message))
          .toList();
    } else {
      throw Error();
    }
  }
}
