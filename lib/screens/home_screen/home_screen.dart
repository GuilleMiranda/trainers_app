import 'package:flutter/material.dart';

import '../favorites/favorites.dart';
import '../profile/profile.dart';
import '../messages/messages.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/homescreen';

  void _favorites(BuildContext context) {
    Navigator.of(context).pushNamed(Favorites.routeName);
  }

  void _messages(BuildContext context) {
    Navigator.of(context).pushNamed(Messages.routeName);
  }

  void _profile(BuildContext context) {
    Navigator.of(context).pushNamed(Profile.routeName);
  }

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainers'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menú',
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favoritos'),
              onTap: () => _favorites(context),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Mensajes'),
              onTap: () => _messages(context),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () => _profile(context),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Column(
              children: [
                Text('John Doe'),
                Text('Entrenador de Algo')
              ],
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
        ],

      ),
    );
  }
}
