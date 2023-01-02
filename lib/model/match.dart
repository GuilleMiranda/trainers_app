class Match {
  final clientId;
  final trainerId;

  const Match(this.clientId, this.trainerId);

  Map<String, dynamic> toJson() {
    return {'clienteId': clientId, 'entrenadorId': trainerId};
  }
}
