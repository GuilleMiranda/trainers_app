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
import 'package:trainers_app/services/chat_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chat extends StatefulWidget {
  static const routeName = '/chat';

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Entrenador trainer;

  final channel = WebSocketChannel.connect(Uri.parse(EnvironmentConstants.wsUrl));
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    if (!ChatClient.stompClient.isActive) {
      ChatClient.stompClient.activate();
    }
  }



  @override
  void dispose() {
    //_channel.sink.close(_channel.closeCode);
    if (!ChatClient.stompClient.isActive) {
      ChatClient.stompClient.deactivate();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    trainer = ModalRoute.of(context)!.settings.arguments as Entrenador;
    ChatClient.setTrainer(trainer);
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
      body: _buildMessageList(ChatClient.messageList),
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
        stream: ChatClient.streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            messageList = snapshot.data;
            return Text(jsonDecode(messageList)['content']);
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
      ChatClient.stompClient.send(
        destination: "/app/chat",
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
