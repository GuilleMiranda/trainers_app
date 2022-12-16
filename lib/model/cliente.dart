import 'package:trainers_app/model/preferencias_cliente.dart';

class Cliente {
  late bool activo;
  late String nombres;
  late String apellidos;
  late String nombreMostrado;
  late int sexoBiologico;

  late DateTime fechaNacimiento;
  late String email;
  late String contrasena;

  late PreferenciasCliente preferenciasCliente;

  Cliente(this.activo, this.nombres, this.apellidos, this.nombreMostrado,
      this.sexoBiologico, this.fechaNacimiento, this.email, this.contrasena);

  Cliente.onRegister(this.email, this.contrasena);

  Cliente.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        contrasena = json['contrasena'],
        nombres = json['nombres'],
        apellidos = json['apellidos'],
        sexoBiologico = json['genero'],
        nombreMostrado = json['nombreMostrado'],
        fechaNacimiento = json['fechaNacimiento'],
        preferenciasCliente =
            PreferenciasCliente.fromJson(json['preferenciasCliente']);

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contrasena': contrasena,
      'nombres': nombres,
      'apellidos': apellidos,
      'genero': sexoBiologico,
      'nombreMostrado': nombreMostrado,
      'fechaNacimiento': fechaNacimiento,
      'preferenciasCliente': preferenciasCliente.toJson()
    };
  }
}
