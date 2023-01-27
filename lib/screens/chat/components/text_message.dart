import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainers_app/model/message.dart';
import 'package:trainers_app/model/session.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final clientId = Provider.of<Session>(context, listen: false).client?.id;
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .backgroundColor
            .withOpacity('${clientId}' == message.senderId ? 1.0 : 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message.contenido,
      ),
    );
  }
}
