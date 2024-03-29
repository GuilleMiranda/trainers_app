import '../model/gender.dart';

abstract class EnvironmentConstants {
  static const String ip = '192.168.0.16';
  static const String apiUrl = 'http://$ip:8080/api/v1/';
  static const String wsUrl = 'ws://$ip:80/chat';

  static const Map<String, String> post_headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const Map<String, String> get_headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static List<Gender> genders = [];
  static Map<String, String> paramProfileText = {
    'CONDICION_SALUD': 'Acepta condiciones de salud especiales',
    'DEPORTE': 'Deporte principal',
    'EXPERIENCIA_DISCIPLINA': 'Años en la disciplina',
    'HORARIO': 'Horario preferido',
    'LOCALIZACION': 'El lugar en el que entrena es',
    'MODALIDAD': 'Entrena principalemte de forma',
    'OBJETIVO': 'Trabaja principalmente para'
  };

  //static List<Map<String, dynamic>> questions;

  // Auth
  static const String post_autenticar_cliente = 'autenticar/cliente';
  static const String post_validar_email = 'validar/email';

  // Chat
  static const String get_mensajes = 'mensajes';

  // Cliente
  static const String get_cliente = 'cliente';
  static const String post_cliente = 'cliente';
  static const String put_cliente = 'cliente';
  static const String delete_favorito = 'favorito';
  static const String get_favoritos = 'favoritos';
  static const String post_favorito = 'favorito';

  // Entrenador
  static const String get_entrenador = 'entrenador';
  static const String get_candidatos = 'candidatos';
  static const String get_entrenadores = 'entrenadores';

  // Preguntas
  static const String get_preguntas = 'preguntas';
  static const String get_preferencias = 'preferencias';

  // Match
  static const get_matches_cliente = 'matchesCliente';
  static const post_match = 'match';
  static const post_unmatch = 'unmatch';

  // Generos
  static const get_generos = 'generos';

  // Imagen
  static const get_imagen = 'imagen';
  static const post_imagen = 'imagen';
}
