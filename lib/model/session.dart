import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/entrenador.dart';

class Session extends ChangeNotifier {
  Cliente? client;
  double? latitude;
  double? longitude;
  List<Entrenador> matchTrainers = [];
  Set<Entrenador> favoriteTrainers = <Entrenador>{};

  void setLatitude(double latitude) {
    this.latitude = latitude;
  }

  void setLongitude(double longitude) {
    this.longitude = longitude;
  }

  void setClient(Cliente client) {
    this.client = client;
    notifyListeners();
  }

  void setFavoriteTrainer(Entrenador trainer) {
    favoriteTrainers.add(trainer);
    notifyListeners();
  }

  void setFavoriteTrainers(Set<Entrenador> trainers) {
    favoriteTrainers = trainers;
    notifyListeners();
  }

  void removeFavoriteTrainer(Entrenador trainer) {
    if (favoriteTrainers.contains(trainer)) favoriteTrainers.remove(trainer);
    notifyListeners();
  }

  void setMatchTrainer(Entrenador trainer) {
    matchTrainers.add(trainer);
    notifyListeners();
  }

  void setMatchTrainers(List<Entrenador> trainers) {
    matchTrainers = trainers;
    notifyListeners();
  }

  void removeMatchTrainer(Entrenador trainer) {
    if (matchTrainers.contains(trainer)) matchTrainers.remove(trainer);
    notifyListeners();
  }

  Entrenador getTrainer(int trainerId) {
    return matchTrainers.firstWhere((element) => element.id == trainerId);
  }

  void remove() {
    client = null;
    favoriteTrainers = <Entrenador>{};
    matchTrainers = [];
    notifyListeners();
  }
}
