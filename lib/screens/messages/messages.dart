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
        itemCount: trainers.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(trainers
                .elementAt(index)
                .id
                .toString()),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                setState(() => trainers.remove(trainers.elementAt(index)));
              }
            },
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.delete),
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.account_circle,
                size: 48,
              ),
              title: Text(
                trainers
                    .elementAt(index)
                    .nombreMostrado
                    .titleCase,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),
              onTap: () =>
                  Navigator.of(context)
                      .pushReplacementNamed(
                      Chat.routeName, arguments: trainers.elementAt(index)),
            ),
          );
        });
  }
}
