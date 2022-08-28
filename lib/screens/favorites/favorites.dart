import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  static const routeName = '/favorites';
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: const Center(
        child: Text('Favoritos'),
      ),
    );
  }
}
