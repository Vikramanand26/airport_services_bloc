// lib/presentation/blocs/airport_bloc/airport_state.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entities/airport.dart';

abstract class AirportState extends Equatable {
  const AirportState();

  @override
  List<Object> get props => [];
}

class AirportInitial extends AirportState {}

class AirportLoading extends AirportState {}

class DeployedAirportsLoaded extends AirportState {
  final List<Airport> airports;

  const DeployedAirportsLoaded(this.airports);

  @override
  List<Object> get props => [airports];
}

class AirportsByEmailDomainLoaded extends AirportState {
  final List<Airport> airports;
  final String emailDomain;

  const AirportsByEmailDomainLoaded(this.airports, this.emailDomain);

  @override
  List<Object> get props => [airports, emailDomain];
}

class AirportError extends AirportState {
  final String message;

  const AirportError(this.message);

  @override
  List<Object> get props => [message];
}