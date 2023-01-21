import 'package:trainers_app/model/match_status.dart';

class Match {
  final int clientId;
  final int trainerId;
  final MatchStatus status;

  const Match(this.clientId, this.trainerId,
      {this.status = MatchStatus.active});

  Match.fromJson(Map<String, dynamic> json)
      : clientId = json['idCliente'],
        trainerId = json['idEntrenador'],
        status = _matchStatusFromString(json['estado']);

  Map<String, dynamic> toJson() {
    return {
      'idCliente': clientId,
      'idEntrenador': trainerId,
      'estado': status.index
    };
  }

  static MatchStatus _matchStatusFromString(String matchStatus) {
    switch (matchStatus) {
      case 'ACTIVO':
        return MatchStatus.active;
      case 'FINALIZADO':
        return MatchStatus.ended;
      case 'CANCELADO':
        return MatchStatus.canceled;
      default:
        return MatchStatus.active;
    }
  }
}
