import 'package:flutter/material.dart';
import 'package:trainers_app/screens/chat/components/text_message.dart';

class Message extends StatelessWidget {
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment:
            true ? MainAxisAlignment.end : MainAxisAlignment.start,
        //message.isSender
        children: [Text('asdf')],
      ),
    );
  }
}
