class PreferenciaCliente {
  late String preferencia;
  late int valor;

  PreferenciaCliente(this.preferencia, this.valor);

  Map<String, dynamic> toJson() {
    return {'preferencia': preferencia, 'valor': valor};
  }

  PreferenciaCliente.fromJson(Map<String, dynamic> preferencias) {
    preferencia = preferencias['preferencia'];
    valor = preferencias['valor'];
  }
}
