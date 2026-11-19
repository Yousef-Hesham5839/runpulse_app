import 'package:equatable/equatable.dart';
import '../../../../core/utils/fitness_calculators.dart';
import '../../../tracking/domain/entities/location_point_entity.dart';

class RunHistoryEntity extends Equatable {
  final String id;
  final DateTime date;
  final double distanceInMeters;
  final int durationInSeconds;
  final int calories;
  final List<LocationPointEntity> routePoints;

  const RunHistoryEntity({
    required this.id,
    required this.date,
    required this.distanceInMeters,
    required this.durationInSeconds,
    required this.calories,
    required this.routePoints,
  });

  double get distanceInKm => distanceInMeters / 1000.0;
  String get formattedDuration => FitnessCalculators.formatDuration(durationInSeconds);
  String get formattedPace => FitnessCalculators.calculatePace(distanceInKm, durationInSeconds);

  @override
  List<Object?> get props => [
        id,
        date,
        distanceInMeters,
        durationInSeconds,
        calories,
        routePoints,
      ];
}