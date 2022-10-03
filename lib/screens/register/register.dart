import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';

class Register extends StatelessWidget {
  static const routeName = '/register';

  String email;
  String contrasena;

  Register(this.email, this.contrasena, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombres'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nombre mostrado'),
                ),
                InputDatePickerFormField(
                  firstDate: DateTime(1900, 1, 1),
                  lastDate: DateTime.now(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
