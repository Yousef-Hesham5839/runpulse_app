import '../../domain/entities/location_point_entity.dart';

class LocationPointModel extends LocationPointEntity {
  const LocationPointModel({
    required super.latitude,
    required super.longitude,
    required super.timestamp,
  });

  factory LocationPointModel.fromCoordinates(double lat, double lng) {
    return LocationPointModel(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
    );
  }

  factory LocationPointModel.fromJson(Map<String, dynamic> json) {
    return LocationPointModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}