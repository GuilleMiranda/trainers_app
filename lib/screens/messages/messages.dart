import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  static const routeName = '/messages';
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensajes'),
      ),
      body: Center(
        child: Text('Messages'),
      ),
    );
  }
}
