class Message {
  final String senderId;
  final String recipientId;
  late String tipo;
  late String contenido;
  late String fecha;

  Message(
      this.senderId, this.recipientId, this.tipo, this.contenido, this.fecha);

  Message.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        recipientId = json['recipientId'],
        tipo = json['tipo'],
        contenido = json['contenido'],
        fecha = json['fecha'];

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'recipientId': recipientId,
      'tipo': tipo,
      'contenido': contenido,
      'fecha': fecha
    };
  }
}
