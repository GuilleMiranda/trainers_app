import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:trainers_app/model/cliente.dart';
import 'package:trainers_app/model/entrenador.dart';
import 'package:trainers_app/model/gender.dart';

class Session extends ChangeNotifier {
  Cliente? client;
  double? latitude;
  double? longitude;
  String? profilePicture;

  List<Gender> genders = [];
  List<Entrenador> matchTrainers = [];
  Set<Entrenador> favoriteTrainers = <Entrenador>{};

  void setProfilePicture(String base64) {
    profilePicture = base64;
  }

  String? getProfilePicture() {
    return profilePicture;
  }

  void setGenders(List<Gender> genders) {
    genders = genders;
  }

  List<Gender> getGenders() {
    return genders;
  }

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
    latitude = null;
    longitude = null;
    profilePicture = null;
    favoriteTrainers = <Entrenador>{};
    matchTrainers = [];
    notifyListeners();
  }
}
