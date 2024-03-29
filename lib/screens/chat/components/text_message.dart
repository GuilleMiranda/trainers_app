import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final prettyDate =
        DateFormat('dd/MM H:m').format(DateTime.parse(message.fecha));
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
              .withOpacity('$clientId' == message.senderId ? 1.0 : 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: clientId.toString() == message.senderId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              textAlign: clientId.toString() == message.senderId
                  ? TextAlign.end
                  : TextAlign.start,
              message.contenido,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              prettyDate,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ));
  }
}
