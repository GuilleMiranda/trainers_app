import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/auth/auth.dart';
import 'package:trainers_app/screens/home_screen/trainer_tile.dart';

import '../../services/services.dart';
import '../favorites/favorites.dart';
import '../messages/messages.dart';
import '../profile/profile.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homescreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Entrenador>> _futureEntrenadores;
  Location location = Location();
  late bool _isServiceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _location().then((value) => print(_locationData.latitude));

    _futureEntrenadores = TrainerService().fetchCandidates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainers'),
      ),
      drawer: Consumer<Session>(
          builder: (context, session, child) => buildDrawer(context, session)),
      body: FutureBuilder(
        future: _futureEntrenadores,
        builder:
            (BuildContext context, AsyncSnapshot<List<Entrenador>> snapshot) =>
                snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TrainerTile(snapshot.data![index]);
                        })
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context, Session session) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Menú',
                    style: Theme.of(context).primaryTextTheme.titleLarge,
                  ),
                ),
                Text(
                  'Hola ${session.client?.nombreMostrado.titleCase}',
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favoritos'),
            onTap: () => _favorites(context),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Mensajes'),
            onTap: () => _messages(context),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () => _profile(context),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).errorColor),
            title: Text(
              'Salir',
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
            onTap: _logout,
          )
        ],
      ),
    );
  }

  void _favorites(BuildContext context) {
    Navigator.of(context).pushNamed(Favorites.routeName);
  }

  void _messages(BuildContext context) {
    Navigator.of(context).pushNamed(Messages.routeName);
  }

  void _profile(BuildContext context) {
    Navigator.of(context).pushNamed(Profile.routeName);
  }

  Future<void> _location() async {
    _isServiceEnabled = await location.serviceEnabled();
    if (!_isServiceEnabled) {
      _isServiceEnabled = await location.requestService();
      if (!_isServiceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationData = await location.getLocation();
  }

  void _logout() {
    Provider.of<Session>(context, listen: false).remove();
    Navigator.of(context).pushReplacementNamed(Auth.routeName);
  }
}
