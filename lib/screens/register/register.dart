import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainers_app/constants/environment.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/screens/preferences_register/preferences.dart';

class Register extends StatelessWidget {
  static const routeName = '/register';

  late Cliente cliente;

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _nombreMostradoController =
      TextEditingController();
  late DateTime _fechaNacimiento = DateTime.now();
  late int sexoBiologico = EnvironmentConstants.genders[0].genderId;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    cliente = ModalRoute.of(context)!.settings.arguments as Cliente;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Completá tus datos"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombres'),
                  controller: _nombresController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe ingresar un nombre.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Apellidos'),
                    controller: _apellidosController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Debe ingresar un apellido.';
                      }
                      return null;
                    }),
                DropdownButtonFormField(
                  decoration:
                      const InputDecoration(labelText: "Sexo biológico"),
                  value: 0,
                  items: EnvironmentConstants.genders.map((e) {
                    return DropdownMenuItem(
                        value: EnvironmentConstants.genders.indexOf(e),
                        child: Text(e.text));
                  }).toList(),
                  onChanged: (value) => sexoBiologico =
                      EnvironmentConstants.genders[value as int].genderId,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nombre mostrado'),
                  controller: _nombreMostradoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Debe ingresar un nombre a ser mostrado.';
                      }
                      return null;
                    }
                ),
                InputDatePickerFormField(
                  firstDate: DateTime(1920, 1, 1),
                  lastDate:
                      DateTime.now().subtract(const Duration(days: 365 * 12)),
                  onDateSaved: (datetime) => _fechaNacimiento = datetime,
                  errorFormatText: 'Ingrese una fécha válida en formato MES/DÍA/AÑO',
                  fieldLabelText: 'Fecha de nacimiento',
                  errorInvalidText: 'Fuera del rango',
                ),
                ElevatedButton(
                  onPressed: () => _register(context),
                  child: const Text('Continuar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      cliente.nombres = _nombresController.text;

      cliente.apellidos = _apellidosController.text;
      cliente.nombreMostrado = _nombreMostradoController.text;
      cliente.fechaNacimiento = DateTime(
          _fechaNacimiento.year, _fechaNacimiento.month, _fechaNacimiento.day);
      cliente.activo = true;
      cliente.sexoBiologico = sexoBiologico;

      Navigator.of(context).pushReplacementNamed(PreferencesRegister.routeName,
          arguments: cliente);
    }
  }
}
