// lib/domain/repositories/airport_repository.dart
import '../entities/airport.dart';

abstract class AirportRepository {
  Future<List<Airport>> getDeployedAirports();
  Future<List<Airport>> getAirportsByEmailDomain(String emailDomain);
}