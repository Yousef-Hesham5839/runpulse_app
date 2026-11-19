import 'package:get_it/get_it.dart';
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
}