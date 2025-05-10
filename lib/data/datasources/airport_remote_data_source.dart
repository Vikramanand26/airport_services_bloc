// lib/data/datasources/airport_remote_data_source.dart
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/airport_model.dart';
import '../models/email_domain_request.dart';

abstract class AirportRemoteDataSource {
  Future<List<AirportModel>> getDeployedAirports();
  Future<List<AirportModel>> getAirportsByEmailDomain(String emailDomain);
}

class AirportRemoteDataSourceImpl implements AirportRemoteDataSource {
  final ApiClient client;

  AirportRemoteDataSourceImpl({required this.client});

  @override
  Future<List<AirportModel>> getDeployedAirports() async {
    try {
      final response = await client.get(ApiConstants.deployedAirportsEndpoint);

      if (response['statusCode'] == 200 && response['resultArray'] != null) {
        return (response['resultArray'] as List)
            .map((airportJson) => AirportModel.fromJson(airportJson))
            .toList();
      } else {
        throw ServerException(message: 'Failed to get deployed airports');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<AirportModel>> getAirportsByEmailDomain(
      String emailDomain) async {
    try {
      final request = EmailDomainRequest(emailDomain: emailDomain);
      final response = await client.post(
        ApiConstants.airportsByEmailDomainEndpoint,
        request.toJson(),
      );

      // Check if response is successful and has resultArray
      if (response['statusCode'] == 200) {
        final resultArray = response['resultArray'];
        if (resultArray == null) {
          return [];
        }

        // If the resultArray contains airportCodes (not full airport objects), map them to full airports
        if (resultArray is List &&
            resultArray.isNotEmpty &&
            resultArray[0]['airportCodes'] != null) {
          // Fetch all deployed airports
          final allAirports = await getDeployedAirports();
          final codes = List<String>.from(resultArray[0]['airportCodes']);
          return allAirports
              .where((a) => codes.contains(a.airportCode))
              .toList();
        }

        // Otherwise, assume resultArray contains full airport objects
        return (resultArray as List)
            .map((airportJson) {
              if (airportJson['airportCode'] == null ||
                  airportJson['airportName'] == null ||
                  airportJson['airportLogo'] == null) {
                print('Warning: Airport data has null fields: $airportJson');
                return null;
              }
              return AirportModel.fromJson(airportJson);
            })
            .where((model) => model != null)
            .cast<AirportModel>()
            .toList();
      } else {
        final errorMessage =
            response['message'] ?? 'Failed to get airports by email domain';
        throw ServerException(message: errorMessage);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
