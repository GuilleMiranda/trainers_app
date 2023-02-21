import '../model/gender.dart';

abstract class EnvironmentConstants {
  static const String ip = '192.168.100.124';
  static const String apiUrl = 'http://$ip:8080/api/v1/';
  static const String wsUrl = 'ws://$ip:80/chat';

  static const Map<String, String> post_headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const Map<String, String> get_headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static List<Gender> genders = [];

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
}
