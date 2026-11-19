import '../entities/run_history_entity.dart';

abstract class RunHistoryRepository {
  Future<void> saveRun(RunHistoryEntity run);
  Future<List<RunHistoryEntity>> getAllRuns();
  Future<void> deleteRun(String id);
}