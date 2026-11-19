import '../entities/location_point_entity.dart';

abstract class LocationRepository {
  Future<bool> checkAndRequestPermission();

  Future<LocationPointEntity> getCurrentLocation();

  Stream<LocationPointEntity> getLocationStream();
}