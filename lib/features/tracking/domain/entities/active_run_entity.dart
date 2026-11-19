import 'package:equatable/equatable.dart';
import '../../../../core/utils/fitness_calculators.dart';
import 'location_point_entity.dart';

enum RunStatus { initial, running, paused, stopped }

class ActiveRunEntity extends Equatable {
  final List<LocationPointEntity> routePoints;
  final double distanceInMeters;
  final int durationInSeconds;
  final RunStatus status;

  const ActiveRunEntity({
    this.routePoints = const [],
    this.distanceInMeters = 0.0,
    this.durationInSeconds = 0,
    this.status = RunStatus.initial,
  });

  double get distanceInKm => distanceInMeters / 1000.0;
  String get formattedDuration => FitnessCalculators.formatDuration(durationInSeconds);
  String get formattedPace => FitnessCalculators.calculatePace(distanceInKm, durationInSeconds);
  int get caloriesBurned => FitnessCalculators.calculateCalories(distanceInKm);

  ActiveRunEntity copyWith({
    List<LocationPointEntity>? routePoints,
    double? distanceInMeters,
    int? durationInSeconds,
    RunStatus? status,
  }) {
    return ActiveRunEntity(
      routePoints: routePoints ?? this.routePoints,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        routePoints,
        distanceInMeters,
        durationInSeconds,
        status,
      ];
}