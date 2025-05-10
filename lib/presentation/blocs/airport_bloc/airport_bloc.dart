// lib/presentation/blocs/airport_bloc/airport_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/exceptions.dart';
import '../../../domain/usecases/get_deployed_airports.dart';
import '../../../domain/usecases/get_airports_by_email_domain.dart';
import 'airport_event.dart';
import 'airport_state.dart';

class AirportBloc extends Bloc<AirportEvent, AirportState> {
  final GetDeployedAirports getDeployedAirports;
  final GetAirportsByEmailDomain getAirportsByEmailDomain;

  AirportBloc({
    required this.getDeployedAirports,
    required this.getAirportsByEmailDomain,
  }) : super(AirportInitial()) {
    on<GetDeployedAirportsEvent>(_onGetDeployedAirports);
    on<GetAirportsByEmailDomainEvent>(_onGetAirportsByEmailDomain);
  }

  Future<void> _onGetDeployedAirports(
      GetDeployedAirportsEvent event,
      Emitter<AirportState> emit,
      ) async {
    emit(AirportLoading());
    try {
      final airports = await getDeployedAirports();
      emit(DeployedAirportsLoaded(airports));
    } on ServerException catch (e) {
      emit(AirportError(e.message));
    } catch (e) {
      emit(AirportError(e.toString()));
    }
  }

  Future<void> _onGetAirportsByEmailDomain(
      GetAirportsByEmailDomainEvent event,
      Emitter<AirportState> emit,
      ) async {
    emit(AirportLoading());
    try {
      final emailParts = event.email.split('@');
      if (emailParts.length != 2) {
        emit(const AirportError('Invalid email format'));
        return;
      }

      final emailDomain = emailParts[1];
      final airports = await getAirportsByEmailDomain(emailDomain);
      emit(AirportsByEmailDomainLoaded(airports, emailDomain));
    } on ServerException catch (e) {
      emit(AirportError(e.message));
    } catch (e) {
      emit(AirportError(e.toString()));
    }
  }
}