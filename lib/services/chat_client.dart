import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:trainers_app/model/entrenador.dart';

import '../constants/environment.dart';

class ChatClient extends ChangeNotifier {
  static StreamController streamController = StreamController();
  static List<String> messageList = [];
  static late Entrenador _trainer;

  static void setTrainer(Entrenador trainer) {
    _trainer = trainer;
  }

  static void clearMessageList() {
    messageList = [];
  }

  static void _onConnect(StompFrame frame) {
    print(_trainer.id);
    print(frame.body);
    stompClient.subscribe(
        destination: "/user/1/queue/messages",
        callback: (frame) {
          Map<String, dynamic> result = jsonDecode(frame.body!);
          messageList.add(result['content']);
          streamController.sink.add(messageList);
        });
  }

  static final stompClient = StompClient(
      config: StompConfig(
          url: EnvironmentConstants.wsUrl,
          //useSockJS: true,
          onConnect: (s) => print(s.body?.length),
          onStompError: (e) => print("stomp err ${e.body}"),
          onWebSocketError: (e) => print("ws err ${e}"),
          onDisconnect: (d) => print("disconnected")));
}
