import 'package:intl/intl.dart';
import 'package:trainers_app/model/gender.dart';

class Entrenador {
  final int id;
  final String descripcion;
  final double calificacion;
  final int experiencia;
  final double latitud;
  final double longitud;
  final bool activo;

  final String nombres;
  final String apellidos;
  final String nombreMostrado;
  final String fechaNacimiento;
  final int genero;

  const Entrenador(
      {required this.id,
      required this.descripcion,
      required this.calificacion,
      required this.experiencia,
      required this.latitud,
      required this.longitud,
      required this.activo,
      required this.nombres,
      required this.apellidos,
      required this.nombreMostrado,
      required this.fechaNacimiento,
      required this.genero});

  factory Entrenador.fromJson(Map<String, dynamic> json) {
    return Entrenador(
        id: json['id'],
        descripcion: json['descripcion'],
        calificacion: json['calificacion'],
        experiencia: json['experiencia'],
        latitud: json['latitud'],
        longitud: json['longitud'],
        activo: json['activo'],
        nombres: json['nombres'],
        apellidos: json['apellidos'],
        nombreMostrado: json['nombreMostrado'],
        fechaNacimiento: json['fechaNacimiento'],
        genero: json['genero']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'calificacion': calificacion,
      'experiencia': experiencia,
      'latitud': latitud,
      'longitud': longitud,
      'activo': activo,
      'nombres': nombres,
      'apellidos': apellidos,
      'nombreMostrado': nombreMostrado,
      'fechaNacimiento': fechaNacimiento,
      'genero': genero
    };
  }
}
