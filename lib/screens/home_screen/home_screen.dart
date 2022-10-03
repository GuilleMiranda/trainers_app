import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/screens/home_screen/entrenador_tile.dart';
import '../favorites/favorites.dart';
import '../profile/profile.dart';
import '../messages/messages.dart';

import '../../services/services.dart';

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

  @override
  void initState() {
    super.initState();
    _location().then((value) => print(_locationData.latitude));

    _futureEntrenadores =  TrainerService().fetchTrainers();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Trainers'),
      ),
      drawer: buildDrawer(context),
      body: FutureBuilder(
        future: _futureEntrenadores,
        builder:
            (BuildContext context, AsyncSnapshot<List<Entrenador>> snapshot) =>
                snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return EntrenadorTile(snapshot.data![index]);
                        })
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
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
    );
  }
}
