import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';

class Session extends ChangeNotifier {
  Cliente? client;

  void add(Cliente client) {
    this.client = client;
    notifyListeners();
  }

  void remove() {
    client = null;
    notifyListeners();
  }
}