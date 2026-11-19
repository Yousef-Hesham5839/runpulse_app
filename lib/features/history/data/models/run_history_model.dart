import '../../../tracking/data/models/location_point_model.dart';
import '../../domain/entities/run_history_entity.dart';

class RunHistoryModel extends RunHistoryEntity {
  const RunHistoryModel({
    required super.id,
    required super.date,
    required super.distanceInMeters,
    required super.durationInSeconds,
    required super.calories,
    required super.routePoints,
  });

  factory RunHistoryModel.fromJson(Map<String, dynamic> json) {
    return RunHistoryModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      distanceInMeters: (json['distanceInMeters'] as num).toDouble(),
      durationInSeconds: json['durationInSeconds'] as int,
      calories: json['calories'] as int,
      routePoints: (json['routePoints'] as List<dynamic>? ?? [])
          .map((p) => LocationPointModel.fromJson(Map<String, dynamic>.from(p)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'distanceInMeters': distanceInMeters,
      'durationInSeconds': durationInSeconds,
      'calories': calories,
      'routePoints': routePoints.map((p) {
        if (p is LocationPointModel) return p.toJson();
        return {
          'latitude': p.latitude,
          'longitude': p.longitude,
          'timestamp': p.timestamp.toIso8601String(),
        };
      }).toList(),
    };
  }

  factory RunHistoryModel.fromEntity(RunHistoryEntity entity) {
    return RunHistoryModel(
      id: entity.id,
      date: entity.date,
      distanceInMeters: entity.distanceInMeters,
      durationInSeconds: entity.durationInSeconds,
      calories: entity.calories,
      routePoints: entity.routePoints,
    );
  }
}