import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/auth/auth.dart';
import 'package:trainers_app/screens/home_screen/trainer_tile.dart';
import 'package:trainers_app/services/match.service.dart';

import '../../model/cliente.dart';
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
  Location location = Location();
  late bool _isServiceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<List<Entrenador>> _candidates(
      BuildContext context, Session session) async {
    int? id = session.client?.id;

    _locationData = (await _location())!;

    session.setLatitude(_locationData.latitude!);
    session.setLongitude(_locationData.longitude!);
    print(_locationData.latitude);
    print(_locationData.longitude);

    return TrainerService()
        .fetchCandidates(id, _locationData.latitude, _locationData.longitude);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainers'),
      ),
      drawer: Consumer<Session>(
          builder: (context, session, child) => buildDrawer(context, session)),
      body: Consumer<Session>(
        builder: (context, session, child) => session.client != null
            ? FutureBuilder(
                future: _candidates(context, session),
                builder: (BuildContext context,
                        AsyncSnapshot<List<Entrenador>> snapshot) =>
                    snapshot.hasData
                        ? snapshot.data!.isEmpty
                            ? const Center(
                                child: Text(
                                    'No hay entrenadores con tus preferenicas. Probá cambiando algunas de ellas.'),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TrainerTile(snapshot.data![index]);
                                })
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
              )
            : const Center(child: CircularProgressIndicator()),
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
            leading: const Icon(Icons.sports_handball_rounded),
            title: const Text('Mis entrenadores'),
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
    Cliente client = Provider.of<Session>(this.context, listen: false).client!;

    ClientService.getFavorites(client.id).then((trainers) =>
        Provider.of<Session>(context, listen: false)
            .setFavoriteTrainers(trainers.toSet()));

    Navigator.of(context).pushNamed(Favorites.routeName);
  }

  void _messages(BuildContext context) {
    var client = Provider.of<Session>(context, listen: false).client;
    int id = -1;
    if (client == null) {
      Provider.of<Session>(context, listen: true).remove();
      Navigator.of(context).pushNamed(Auth.routeName);
      return;
    }

    id = client.id;
    MatchService.getClientMatches(id).then((trainers) =>
        Provider.of<Session>(context, listen: false)
            .setMatchTrainers(trainers));

    Navigator.of(context).pushNamed(Messages.routeName);
  }

  void _profile(BuildContext context) {
    Navigator.of(context).pushNamed(Profile.routeName);
  }

  Future<LocationData?> _location() async {
    _isServiceEnabled = await location.serviceEnabled();
    if (!_isServiceEnabled) {
      _isServiceEnabled = await location.requestService();
      if (!_isServiceEnabled) return null;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return null;
    }

    return await location.getLocation();
  }

  void _logout() {
    Provider.of<Session>(context, listen: false).remove();
    Navigator.of(context).pushReplacementNamed(Auth.routeName);
  }
}
