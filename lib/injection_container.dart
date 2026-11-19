import 'package:get_it/get_it.dart';
import 'features/history/data/datasources/run_local_data_source.dart';
import 'features/history/data/repositories/run_history_repository_impl.dart';
import 'features/history/domain/repositories/run_history_repository.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/tracking/data/datasources/geolocator_data_source.dart';
import 'features/tracking/data/repositories/location_repository_impl.dart';
import 'features/tracking/domain/repositories/location_repository.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Tracking Feature
  sl.registerLazySingleton<GeolocatorDataSource>(() => GeolocatorDataSource());
  sl.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(sl()));
  sl.registerFactory(() => TrackingBloc(sl()));

  // History Feature
  sl.registerLazySingleton<RunLocalDataSource>(() => RunLocalDataSource());
  sl.registerLazySingleton<RunHistoryRepository>(
      () => RunHistoryRepositoryImpl(sl()));
  sl.registerFactory(() => HistoryBloc(sl()));
}