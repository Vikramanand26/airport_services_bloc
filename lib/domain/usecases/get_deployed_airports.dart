// lib/domain/usecases/get_deployed_airports.dart
import '../entities/airport.dart';
import '../repositories/airport_repository.dart';

class GetDeployedAirports {
  final AirportRepository repository;

  GetDeployedAirports(this.repository);

  Future<List<Airport>> call() async {
    return await repository.getDeployedAirports();
  }
}