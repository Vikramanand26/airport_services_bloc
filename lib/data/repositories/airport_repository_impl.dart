// lib/data/repositories/airport_repository_impl.dart
import '../../core/errors/exceptions.dart';
import '../../domain/entities/airport.dart';
import '../../domain/repositories/airport_repository.dart';
import '../datasources/airport_remote_data_source.dart';

class AirportRepositoryImpl implements AirportRepository {
  final AirportRemoteDataSource remoteDataSource;

  AirportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Airport>> getDeployedAirports() async {
    try {
      final airportModels = await remoteDataSource.getDeployedAirports();
      return airportModels;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<List<Airport>> getAirportsByEmailDomain(String emailDomain) async {
    try {
      final airportModels = await remoteDataSource.getAirportsByEmailDomain(emailDomain);
      return airportModels;
    } on ServerException {
      rethrow;
    }
  }
}