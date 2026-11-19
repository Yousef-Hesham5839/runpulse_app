import 'package:equatable/equatable.dart';
import '../../domain/entities/active_run_entity.dart';
import '../../domain/entities/location_point_entity.dart';

class TrackingState extends Equatable {
  final ActiveRunEntity activeRun;
  final LocationPointEntity? currentLocation;
  final bool isLoading;
  final String? errorMessage;

  const TrackingState({
    this.activeRun = const ActiveRunEntity(),
    this.currentLocation,
    this.isLoading = false,
    this.errorMessage,
  });

  TrackingState copyWith({
    ActiveRunEntity? activeRun,
    LocationPointEntity? currentLocation,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TrackingState(
      activeRun: activeRun ?? this.activeRun,
      currentLocation: currentLocation ?? this.currentLocation,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        activeRun,
        currentLocation,
        isLoading,
        errorMessage,
      ];
}