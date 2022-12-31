import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trainers_app/model/session.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile';

  const Profile({super.key});

  final _clientDataLength = 4;

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
      ),
      body: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Consumer<Session>(
      builder: (context, session, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: SizedBox(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        minRadius: 100,
                        backgroundImage: NetworkImage(
                            'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
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
              Center(
                child: TextButton(
                  onPressed: null,
                  child: Text('Mis preferencias'),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: null,
                  child: Text('Cambiar contraseña'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
