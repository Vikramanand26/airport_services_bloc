// lib/presentation/blocs/airport_bloc/airport_event.dart
import 'package:equatable/equatable.dart';

abstract class AirportEvent extends Equatable {
  const AirportEvent();

  @override
  List<Object> get props => [];
}

class GetDeployedAirportsEvent extends AirportEvent {}

class GetAirportsByEmailDomainEvent extends AirportEvent {
  final String email;

  const GetAirportsByEmailDomainEvent(this.email);

  @override
  List<Object> get props => [email];
}