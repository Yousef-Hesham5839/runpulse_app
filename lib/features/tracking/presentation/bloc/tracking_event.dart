import 'package:equatable/equatable.dart';
import '../../domain/entities/location_point_entity.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class InitLocationEvent extends TrackingEvent {}

class StartRunEvent extends TrackingEvent {}

class PauseRunEvent extends TrackingEvent {}

class ResumeRunEvent extends TrackingEvent {}

class StopRunEvent extends TrackingEvent {}

class ResetRunEvent extends TrackingEvent {}

class LocationUpdatedEvent extends TrackingEvent {
  final LocationPointEntity location;
  const LocationUpdatedEvent(this.location);

  @override
  List<Object?> get props => [location];
}

class TimerTickedEvent extends TrackingEvent {}