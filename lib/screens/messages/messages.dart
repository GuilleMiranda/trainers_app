import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/chat/chat.dart';

class Messages extends StatefulWidget {
  static const routeName = '/messages';

  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mensajes'),
        ),
        body: Consumer<Session>(
          builder: (context, session, child) {
            if (session.matchTrainers.isEmpty) {
              return const Center(
                child: Text('Elegí a tu entrenador para verlo acá.'),
              );
            }
            return _buildMatchList(session.matchTrainers);
          },
        ));
  }

  Widget _buildMatchList(List<Entrenador> trainers) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: trainers.length,

        itemBuilder: (context, index) {
          return ListTile(
            leading: SizedBox(
              width: 52,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/thumb/${_gender(trainers.elementAt(index))}/$index.jpg',
                  scale: 0.3,
                ),
                radius: 52,
              ),
            ),
            title: Text(
              trainers.elementAt(index).nombreMostrado.titleCase,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () => Navigator.of(context).pushReplacementNamed(
                Chat.routeName,
                arguments: trainers.elementAt(index)),
          );
        });
  }

  String _gender(Entrenador trainer) {
    return 'male';
  }
}
