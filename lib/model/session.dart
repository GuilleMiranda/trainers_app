import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/services/services.dart';

class Session extends ChangeNotifier {
  Cliente? client;

  void update(Cliente client) {
    this.client = client;
    notifyListeners();
  }

  void remove() {
    client = null;
    notifyListeners();
  }
}
