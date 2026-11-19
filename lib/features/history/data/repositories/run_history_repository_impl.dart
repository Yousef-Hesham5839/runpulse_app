import '../../domain/entities/run_history_entity.dart';
import '../../domain/repositories/run_history_repository.dart';
import '../datasources/run_local_data_source.dart';
import '../models/run_history_model.dart';

class RunHistoryRepositoryImpl implements RunHistoryRepository {
  final RunLocalDataSource localDataSource;

  RunHistoryRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveRun(RunHistoryEntity run) {
    return localDataSource.saveRun(RunHistoryModel.fromEntity(run));
  }

  @override
  Future<List<RunHistoryEntity>> getAllRuns() {
    return localDataSource.getAllRuns();
  }

  @override
  Future<void> deleteRun(String id) {
    return localDataSource.deleteRun(id);
  }
}