import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../models/location_point_model.dart';

class GeolocatorDataSource {
  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationFailure('Location services are disabled on your device.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationFailure('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationFailure(
          'Location permissions are permanently denied. Please enable them in settings.');
    }

    return true;
  }

  Future<LocationPointModel> getCurrentLocation() async {
    await checkAndRequestPermission();
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return LocationPointModel(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );
  }

  Stream<LocationPointModel> getLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: AppConstants.locationDistanceFilterMeters,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (position) => LocationPointModel(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: position.timestamp,
      ),
    );
  }
}