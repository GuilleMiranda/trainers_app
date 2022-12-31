import 'package:flutter/material.dart';
import 'package:trainers_app/model/preferencia_cliente.dart';
import 'package:intl/intl.dart';

class Cliente extends ChangeNotifier {
  late bool activo;
  late String nombres;
  late String apellidos;
  late String nombreMostrado;
  late int sexoBiologico;

  late DateTime fechaNacimiento;
  late String email;
  late String contrasena;

  late List<PreferenciaCliente> preferenciasCliente;

  Cliente(this.activo, this.nombres, this.apellidos, this.nombreMostrado,
      this.sexoBiologico, this.fechaNacimiento, this.email, this.contrasena) {
    preferenciasCliente = [];
  }

  Cliente.onRegister(this.email, this.contrasena) {
    preferenciasCliente = [];
  }

  Cliente.copyOf(Cliente cliente) {
    this.activo = true;
    this.nombres = cliente.nombres;
    this.apellidos = cliente.apellidos;
    this.nombreMostrado = cliente.nombreMostrado;
    this.sexoBiologico = cliente.sexoBiologico;
    this.fechaNacimiento = cliente.fechaNacimiento;
    this.email = cliente.email;
    this.contrasena = cliente.contrasena;
    this.preferenciasCliente = List.of(cliente.preferenciasCliente);
  }

  Cliente.fromJson(Map<String, dynamic> json)
      : activo = true,
        email = json['email'],
        contrasena = json['contrasena'] ?? '',
        nombres = json['nombres'],
        apellidos = json['apellidos'],
        sexoBiologico = json['genero'],
        nombreMostrado = json['nombreMostrado'],
        fechaNacimiento =
            DateFormat('dd/MM/yyyy').parse(json['fechaNacimiento']),
        preferenciasCliente = <PreferenciaCliente>[
          ...(json['preferencias'] as List)
              .map((e) => PreferenciaCliente(e['preferencia'], e['valor']))
              .toList()
        ];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contrasena': contrasena,
      'nombres': nombres,
      'apellidos': apellidos,
      'genero': sexoBiologico,
      'nombreMostrado': nombreMostrado,
      'fechaNacimiento': DateFormat('dd/MM/yyyy').format(fechaNacimiento),
      'preferencias': [
        ...preferenciasCliente
            .map((preferencia) => preferencia.toJson())
            .toList()
      ],
    };
  }

  PreferenciaCliente? getPreferencia(String preference) {
    for (var element in preferenciasCliente) {
      if (element.preferencia == preference) {
        return element;
      }
    }
    return null;
  }

  void setPreferencia(String preference, int value) {
    bool hasPreference = false;
    for (var element in preferenciasCliente) {
      if (element.preferencia == preference) {
        element.valor = value;
        hasPreference = true;
      }
    }

    if (!hasPreference) {
      preferenciasCliente.add(PreferenciaCliente(preference, value));
    }
  }

  String getSexoBiologico() {
    switch (sexoBiologico) {
      case 0:
        {
          return 'Femenino';
        }
      case 1:
        {
          return 'Masculino';
        }
      case 2:
        {
          return 'Otros';
        }
      case 3:
        {
          return 'Prefiero no decirlo';
        }
      default:
        {
          return 'N/E';
        }
    }
  }
}
