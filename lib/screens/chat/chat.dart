import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/message.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/match.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/chat/components/text_message.dart';
import 'package:trainers_app/services/match.service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chat extends StatefulWidget {
  static const routeName = '/chat';

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Entrenador trainer;
  late Cliente? client;

  late WebSocketChannel _channel;
  TextEditingController messageController = TextEditingController();

  late Message _message;

  final _messageList = [].reversed.toList();

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    trainer = ModalRoute.of(context)!.settings.arguments as Entrenador;

    client = Provider.of<Session>(context).client;

    var url =
        '${EnvironmentConstants.wsUrl}?senderId=${client?.id}&recipientId=${trainer.id}';
    print(url);

    _message = Message('${client?.id}', '${trainer.id}', 'TEXT', '', '');

    _channel = WebSocketChannel.connect(Uri.parse(url));

    return Scaffold(
      appBar: _buildAppBar(trainer.nombreMostrado),
      body: _buildMessageList(),
      bottomSheet: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormField(
                  textInputAction: TextInputAction.send,
                  onFieldSubmitted: (_) => _sendMessage,
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

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(title),
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
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Message incomingMessage =
              Message.fromJson(jsonDecode('${snapshot.data}'));
          _messageList.add(incomingMessage);
        }

        return ListView.builder(
          itemCount: _messageList.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: _messageList.elementAt(index).senderId ==
                      client?.id.toString()
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextMessage(message: _messageList.elementAt(index))
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
  
  void _sendMessage() {
    if (messageController.text.isNotEmpty) {
      _message.contenido = messageController.text;
      _message.fecha = '2023-01-24T22:22:30+01:00';

      _channel.sink.add(jsonEncode(_message.toJson()));

      setState(() => _messageList.add(_message));
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
