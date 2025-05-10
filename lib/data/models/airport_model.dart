// lib/data/models/airport_model.dart

import '../../domain/entities/airport.dart';

class AirportModel extends Airport {
  AirportModel({
    required String airportCode,
    required String airportName,
    required String airportLogo,
  }) : super(
    airportCode: airportCode,
    airportName: airportName,
    airportLogo: airportLogo,
  );

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      airportCode: json['airportCode'],
      airportName: json['airportName'],
      airportLogo: json['airportLogo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airportCode': airportCode,
      'airportName': airportName,
      'airportLogo': airportLogo,
    };
  }
}