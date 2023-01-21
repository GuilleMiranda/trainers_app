import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trainers_app/model/preferencia_cliente.dart';

class Cliente extends ChangeNotifier {
  late int id;
  late bool activo;
  late String nombres;
  late String apellidos;
  late String nombreMostrado;
  late int sexoBiologico;

  late DateTime fechaNacimiento;
  late String email;
  late String contrasena;

  late List<PreferenciaCliente> preferenciasCliente;

  Cliente(this.id, this.activo, this.nombres, this.apellidos, this.nombreMostrado,
      this.sexoBiologico, this.fechaNacimiento, this.email, this.contrasena) {
    preferenciasCliente = [];
  }

  Cliente.onRegister(this.email, this.contrasena) {
    preferenciasCliente = [];
  }

  Cliente.copyOf(Cliente cliente) {
    id = cliente.id;
    activo = true;
    nombres = cliente.nombres;
    apellidos = cliente.apellidos;
    nombreMostrado = cliente.nombreMostrado;
    sexoBiologico = cliente.sexoBiologico;
    fechaNacimiento = cliente.fechaNacimiento;
    email = cliente.email;
    contrasena = cliente.contrasena;
    preferenciasCliente = List.of(cliente.preferenciasCliente);
  }

  Cliente.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        activo = true,
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
