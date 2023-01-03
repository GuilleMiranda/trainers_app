import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/entrenador.dart';

class Session extends ChangeNotifier {
  Cliente? client;
  List<Entrenador> matchTrainers = [];
  Set<Entrenador> favoriteTrainers = <Entrenador>{};

  void setClient(Cliente client) {
    this.client = client;
    notifyListeners();
  }

  void setFavoriteTrainer(Entrenador trainer) {
    favoriteTrainers.add(trainer);
    notifyListeners();
  }

  void removeFavoriteTrainer(Entrenador trainer) {
    favoriteTrainers.remove(trainer);
    notifyListeners();
  }

  void setMatchTrainer(Entrenador trainer) {
    matchTrainers.add(trainer);
    notifyListeners();
  }

  void removeMatchTrainer(Entrenador trainer) {
    matchTrainers.remove(trainer);
    notifyListeners();
  }

  void remove() {
    client = null;
    favoriteTrainers = <Entrenador>{};
    matchTrainers = [];
    notifyListeners();
  }
}
