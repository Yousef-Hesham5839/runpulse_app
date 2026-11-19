import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/run_history_entity.dart';
import '../../domain/repositories/run_history_repository.dart';

// --- Events ---
abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {}

class SaveRunEvent extends HistoryEvent {
  final RunHistoryEntity run;
  const SaveRunEvent(this.run);
  @override
  List<Object?> get props => [run];
}

class DeleteRunEvent extends HistoryEvent {
  final String id;
  const DeleteRunEvent(this.id);
  @override
  List<Object?> get props => [id];
}

// --- States ---
abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}
class HistoryLoading extends HistoryState {}
class HistoryLoaded extends HistoryState {
  final List<RunHistoryEntity> runs;
  const HistoryLoaded(this.runs);
  @override
  List<Object?> get props => [runs];
}
class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- BLoC ---
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final RunHistoryRepository repository;

  HistoryBloc(this.repository) : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<SaveRunEvent>(_onSaveRun);
    on<DeleteRunEvent>(_onDeleteRun);
  }

  Future<void> _onLoadHistory(
      LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final runs = await repository.getAllRuns();
      emit(HistoryLoaded(runs));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onSaveRun(
      SaveRunEvent event, Emitter<HistoryState> emit) async {
    try {
      await repository.saveRun(event.run);
      add(LoadHistoryEvent());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onDeleteRun(
      DeleteRunEvent event, Emitter<HistoryState> emit) async {
    try {
      await repository.deleteRun(event.id);
      add(LoadHistoryEvent());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}