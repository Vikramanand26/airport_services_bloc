// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'data/datasources/airport_remote_data_source.dart';
import 'data/repositories/airport_repository_impl.dart';
import 'domain/repositories/airport_repository.dart';
import 'domain/usecases/get_deployed_airports.dart';
import 'domain/usecases/get_airports_by_email_domain.dart';
import 'presentation/blocs/airport_bloc/airport_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
        () => AirportBloc(
      getDeployedAirports: sl(),
      getAirportsByEmailDomain: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDeployedAirports(sl()));
  sl.registerLazySingleton(() => GetAirportsByEmailDomain(sl()));

  // Repository
  sl.registerLazySingleton<AirportRepository>(
        () => AirportRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AirportRemoteDataSource>(
        () => AirportRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient(client: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
