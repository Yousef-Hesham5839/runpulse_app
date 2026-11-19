import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/active_run_entity.dart';
import '../../domain/entities/location_point_entity.dart';
import '../../domain/repositories/location_repository.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final LocationRepository locationRepository;

  StreamSubscription<LocationPointEntity>? _locationSubscription;
  Timer? _timer;

  TrackingBloc(this.locationRepository) : super(const TrackingState()) {
    on<InitLocationEvent>(_onInitLocation);
    on<StartRunEvent>(_onStartRun);
    on<PauseRunEvent>(_onPauseRun);
    on<ResumeRunEvent>(_onResumeRun);
    on<StopRunEvent>(_onStopRun);
    on<ResetRunEvent>(_onResetRun);
    on<LocationUpdatedEvent>(_onLocationUpdated);
    on<TimerTickedEvent>(_onTimerTicked);
  }

  Future<void> _onInitLocation(
      InitLocationEvent event, Emitter<TrackingState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final initialLoc = await locationRepository.getCurrentLocation();
      emit(state.copyWith(
        isLoading: false,
        currentLocation: initialLoc,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onStartRun(StartRunEvent event, Emitter<TrackingState> emit) {
    if (state.activeRun.status == RunStatus.running) return;

    _startTimer();
    _startLocationStream();

    emit(state.copyWith(
      activeRun: state.activeRun.copyWith(status: RunStatus.running),
    ));
  }

  void _onPauseRun(PauseRunEvent event, Emitter<TrackingState> emit) {
    _timer?.cancel();
    _locationSubscription?.pause();

    emit(state.copyWith(
      activeRun: state.activeRun.copyWith(status: RunStatus.paused),
    ));
  }

  void _onResumeRun(ResumeRunEvent event, Emitter<TrackingState> emit) {
    _startTimer();
    _locationSubscription?.resume();

    emit(state.copyWith(
      activeRun: state.activeRun.copyWith(status: RunStatus.running),
    ));
  }

  void _onStopRun(StopRunEvent event, Emitter<TrackingState> emit) {
    _stopTracking();

    emit(state.copyWith(
      activeRun: state.activeRun.copyWith(status: RunStatus.stopped),
    ));
  }

  void _onResetRun(ResetRunEvent event, Emitter<TrackingState> emit) {
    _stopTracking();

    emit(state.copyWith(
      activeRun: const ActiveRunEntity(status: RunStatus.initial),
    ));
  }

  void _onLocationUpdated(
      LocationUpdatedEvent event, Emitter<TrackingState> emit) {
    final newPoint = event.location;
    final currentRun = state.activeRun;

    if (currentRun.status != RunStatus.running) {
      emit(state.copyWith(currentLocation: newPoint));
      return;
    }

    double additionalDistance = 0.0;
    if (currentRun.routePoints.isNotEmpty) {
      final lastPoint = currentRun.routePoints.last;
      additionalDistance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );
    }

    final updatedPoints = List<LocationPointEntity>.from(currentRun.routePoints)
      ..add(newPoint);

    emit(state.copyWith(
      currentLocation: newPoint,
      activeRun: currentRun.copyWith(
        routePoints: updatedPoints,
        distanceInMeters: currentRun.distanceInMeters + additionalDistance,
      ),
    ));
  }

  void _onTimerTicked(TimerTickedEvent event, Emitter<TrackingState> emit) {
    if (state.activeRun.status == RunStatus.running) {
      emit(state.copyWith(
        activeRun: state.activeRun.copyWith(
          durationInSeconds: state.activeRun.durationInSeconds + 1,
        ),
      ));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTickedEvent());
    });
  }

  void _startLocationStream() {
    _locationSubscription?.cancel();
    _locationSubscription = locationRepository.getLocationStream().listen(
      (point) {
        add(LocationUpdatedEvent(point));
      },
      onError: (err) {
      },
    );
  }

  void _stopTracking() {
    _timer?.cancel();
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  Future<void> close() {
    _stopTracking();
    return super.close();
  }
}