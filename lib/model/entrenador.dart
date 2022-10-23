import 'dart:ffi';

class Entrenador {
  final double calificacion;
  final int experiencia;
  final double latitud;
  final double longitud;
  final bool activo;

  final String nombres;
  final String apellidos;
  final String nombreMostrado;
  final String fechaNacimiento;

  const Entrenador({
    required this.calificacion,
    required this.experiencia,
    required this.latitud,
    required this.longitud,
    required this.activo,
    required this.nombres,
    required this.apellidos,
    required this.nombreMostrado,
    required this.fechaNacimiento,
  });

  factory Entrenador.fromJson(Map<String, dynamic> json) {
    return Entrenador(
      calificacion: json['calificacion'],
      experiencia: json['experiencia'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      activo: json['activo'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      nombreMostrado: json['nombreMostrado'],
      fechaNacimiento: json['fechaNacimiento'],
    );
  }
}
