import '../../domain/entities/location_point_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/geolocator_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final GeolocatorDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<bool> checkAndRequestPermission() {
    return dataSource.checkAndRequestPermission();
  }

  @override
  Future<LocationPointEntity> getCurrentLocation() {
    return dataSource.getCurrentLocation();
  }

  @override
  Stream<LocationPointEntity> getLocationStream() {
    return dataSource.getLocationStream();
  }
}