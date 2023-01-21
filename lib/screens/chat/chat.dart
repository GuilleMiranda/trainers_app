import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/match.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/services/match.service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chat extends StatefulWidget {
  static const routeName = '/chat';

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Entrenador trainer;

  TextEditingController messageController = TextEditingController();

  StreamController<List<String>> streamController = StreamController();
  var messageList = <String>[];

  final stompClient = StompClient(
      config: StompConfig(
          url: EnvironmentConstants.wsUrl,
          useSockJS: true,
          onConnect: (c) => print(c.body),
          onStompError: (e) => "stomp err ${e.body}",
          onWebSocketError: (e) => "ws err ${e}",
          onDisconnect: (d) => print("disconnected")));

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
        destination: "/",
        callback: (frame) {
          Map<String, dynamic> result = jsonDecode(frame.body!);
          messageList.add(result['content']);
          streamController.sink.add(messageList);
        });
  }

  @override
  void initState() {
    stompClient.activate();
  }

  //WebSocketChannel.connect(Uri.parse("ws://192.168.0.10:80/ws"));

  @override
  void dispose() {
    //_channel.sink.close(_channel.closeCode);
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    trainer = ModalRoute.of(context)!.settings.arguments as Entrenador;
    return Scaffold(
      appBar: AppBar(
        title: Text(trainer.nombreMostrado),
        actions: [
          PopupMenuButton(
              onSelected: _handleSelectMenuItem,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                      value: 'UNMATCH', child: Text('Cancelar match'))
                ];
              })
        ],
      ),
      body: _buildMessageList(messageList),
      bottomSheet: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                      hintText: 'Escribí un mensaje.',
                      fillColor: Theme.of(context).disabledColor,
                      focusColor: Theme.of(context).backgroundColor),
                ),
              ),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).backgroundColor,
              )
            ],
          )),
    );
  }

  Widget _buildMessageList(messageList) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            messageList = snapshot.data;
            return Text(jsonDecode(messageList)['contenido']);
            // return ListView.builder(itemBuilder: (context, index) {
            //   return _buildChatItem(messageList[index]);
            // });
          }
        },
      ),
    );
  }

  Widget _buildChatItem(data) {
    return Text(data);
  }

  void _sendMessage() {
    if (messageController.text.isNotEmpty) {
      stompClient.send(
        destination: "/chat",
        body: json.encode({
          "id": "1",
          "chatId": "1",
          "senderId": "1",
          "recipientId": "1",
          "senderName": "Pepe",
          "recipientName": "Papa",
          "content": messageController.text,
          "timestamp": "2022-01-07 14:53:05",
          "status": "DELIVERED"
        }),
      );
      // _channel.sink.add(messageController.text);
      messageController.clear();
    }
  }

  Future<void> _handleSelectMenuItem(String value) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: Text('¿Querés eliminar a este entrenador de tu lista?'),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge),
                  onPressed: () {
                    _unmatch();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirmar'))
            ],
          );
        });
  }

  void _unmatch() {
    int? clientId = Provider.of<Session>(context, listen: false).client?.id;

    MatchService.postUnmatch(Match(clientId!, trainer.id)).then((value) {
      Provider.of<Session>(context, listen: false).removeMatchTrainer(trainer);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('¡Listo!'),
        ),
      );
    });
  }
}
