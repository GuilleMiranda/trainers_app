import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/match.dart';
import 'package:trainers_app/model/message.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/chat/components/text_message.dart';
import 'package:trainers_app/screens/trainer_detail/trainer_detail.dart';
import 'package:trainers_app/services/chat.service.dart';
import 'package:trainers_app/services/match.service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chat extends StatefulWidget {
  static const routeName = '/chat';
  final Map<String, dynamic> arguments;

  const Chat({super.key, required this.arguments});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late var clientId;
  late var trainerId;
  late var trajoMensajes = false;

  late WebSocketChannel _channel;
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Message _outMessageTemplate;

  late final List<Message> _messageList = [];

  @override
  void initState() {
    clientId = widget.arguments['clientId'];
    trainerId = widget.arguments['id'];
    _outMessageTemplate = Message('$clientId', '$trainerId', 'TEXT', '', '');

    var url =
        '${EnvironmentConstants.wsUrl}?senderId=$clientId&recipientId=$trainerId';
    print(url);
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _connectChannel();

    super.initState();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget.arguments['nombreMostrado']),
      body: FutureBuilder(
          future: ChatService.fetchMessages('$clientId', '$trainerId'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!trajoMensajes) {
                _messageList.addAll([...(snapshot.data as List)]);
                trajoMensajes = true;
              }
              return Container(
                  height: MediaQuery.of(context).size.height * 0.78,
                  child: _buildMessageList());
            }
          }),
      bottomSheet: _buildSendInput(context),
    );
  }

  void _connectChannel() {
    _channel.stream.listen((message) {
      Message incomingMessage = Message.fromJson(jsonDecode('$message'));
      if (incomingMessage.senderId.toString() == trainerId.toString()) {
        _messageList.insert(0, incomingMessage);
        setState(() {});
      }
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Ocurrió un error',
        style: TextStyle(color: Colors.red),
      )));
      Navigator.of(context).pop();
    });
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      reverse: true,
      controller: _scrollController,
      itemCount: _messageList.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment:
              _messageList.elementAt(index).senderId == clientId.toString()
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [TextMessage(message: _messageList.elementAt(index))],
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _sendMessage() {
    if (messageController.text.isNotEmpty) {
      Message send = Message.copyOf(_outMessageTemplate);
      send.contenido = messageController.text;

      var utcDate = DateTime.now();

      send.fecha = DateFormat("yyyy-MM-ddTHH:mm:ss-03:00").format(utcDate);

      print(jsonEncode(send.toJson()));
      _channel.sink.add(jsonEncode(send.toJson()));

      var offset = DateTime.now().timeZoneOffset;
      send.fecha = DateFormat("yyyy-MM-ddTHH:mm:ss-03:00").format(utcDate.add(offset));

      setState(() => _messageList.insert(0, send));
      messageController.clear();
    }
    FocusScope.of(context).focusedChild?.unfocus();

    _scrollDown();
  }

  void _unmatch() {
    MatchService.postUnmatch(Match(clientId!, trainerId)).then((value) {
      Entrenador trainer =
          Provider.of<Session>(context, listen: false).getTrainer(trainerId);

      Provider.of<Session>(context, listen: false).removeMatchTrainer(trainer);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('¡Listo!'),
        ),
      );
    });
  }

  SizedBox _buildSendInput(BuildContext context) {
    return SizedBox(
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
      ),
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
                    value: 'PROFILE', child: Text('Ver perfil')),
                const PopupMenuItem(
                    value: 'UNMATCH', child: Text('Cancelar match'))
              ];
            })
      ],
    );
  }

  Future<void> _handleSelectMenuItem(String value) {
    switch (value) {
      case 'PROFILE':
        Entrenador trainer =
            Provider.of<Session>(context, listen: false).getTrainer(trainerId);
        return Navigator.of(context)
            .pushReplacementNamed(TrainerDetail.routeName, arguments: trainer);
      case 'UNMATCH':
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
      default:
        return showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text('Este es un mensaje secreto. shhh'),
                ));
    }
  }
}
