// lib/domain/usecases/get_airports_by_email_domain.dart
import '../../main.dart';
import '../entities/airport.dart';
import '../repositories/airport_repository.dart';

class GetAirportsByEmailDomain {
  final AirportRepository repository;

  GetAirportsByEmailDomain(this.repository);

  Future<List<Airport>> call(String emailDomain) async {
    return await repository.getAirportsByEmailDomain(emailDomain);
  }
}