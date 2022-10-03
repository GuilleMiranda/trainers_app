import 'package:trainers_app/services/services.dart';

import '../model/entrenador.dart';

class TrainerRepository {
  const TrainerRepository({
    required this.service
  });

  final TrainerService service;

  Future<List<Entrenador>> getTrainer() async => service.fetchTrainers();
}