import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/session.dart';
import 'package:trainers_app/screens/preferences_client/preferences.dart';
import 'package:trainers_app/services/image.service.dart';
import '../../model/Image.dart' as Imagen;

class Profile extends StatefulWidget {
  static const routeName = '/profile';

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  late Imagen.Image image = Imagen.Image.newImage();

  List<ListTile> _clientData(Session session) {
    var dataList = <ListTile>[
      ListTile(
        title: Text('Nombres y apellidos'),
        subtitle: Text('${session.client?.nombres} ${session.client?.apellidos}'
            .titleCase),
      ),
      ListTile(
        title: Text('Fecha de nacimiento'),
        subtitle: Text(
            '${session.client?.fechaNacimiento.day}/${session.client?.fechaNacimiento.month}/${session.client?.fechaNacimiento.year}'),
      ),
      ListTile(
        title: Text('Sexo biológico'),
        subtitle: Text('${session.client?.getSexoBiologico()}'.titleCase),
      ),
      ListTile(
        title: Text('Correo electrónico'),
        subtitle: Text('${session.client?.email}'.toLowerCase()),
      )
    ];
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: [
          IconButton(
              onPressed: () => _clientePreferences(context),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Consumer<Session>(
      builder: (context, session, child) {
        image.userId = session.client!.id;
        image.imageType = 'FOTO_PERFIL';
        image.userType = 'CLIENTE';
        return SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var file = await _picker.pickImage(
                              source: ImageSource.gallery);
                          final bytes = await file?.readAsBytes();
                          final base64Img = base64Encode(bytes!);

                          image.base64 = base64Img;

                          await ImageService.postImage(image);

                          setState(() {
                            Provider.of<Session>(context, listen: false)
                                .setProfilePicture(base64Img);
                            session.profilePicture = base64Img;
                          });
                        },
                        child: session.profilePicture != null
                            ? CircleAvatar(
                                maxRadius: 100,
                                child: ClipOval(
                                  child: Image.memory(
                                      base64Decode(session.profilePicture!)),
                                ),
                              )
                            : FutureBuilder(
                                future: ImageService.getImage(image),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return CircleAvatar(
                                      maxRadius: 100,
                                      child: ClipOval(
                                        child: Image.memory(base64Decode(
                                            (snapshot.data as Imagen.Image)
                                                .base64)),
                                      ),
                                    );
                                  }
                                  return CircleAvatar(
                                    maxRadius: 100,
                                    child: Text(
                                        '${session.client?.nombres[0]}${session.client?.apellidos[0]}',
                                        style: const TextStyle(fontSize: 48)),
                                  );
                                },
                              ),
                      ),
                      Text(
                        '${session.client?.nombreMostrado}'.titleCase,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              ..._clientData(session),
              const Center(
                child: TextButton(
                  onPressed: null,
                  child: Text('Cambiar contraseña'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _clientePreferences(BuildContext context) {
    Navigator.of(context).pushNamed(PreferencesClient.routeName);
  }
}
