import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../models/run_history_model.dart';

class RunLocalDataSource {
  Box? _runBox;

  Future<Box> _getBox() async {
    if (_runBox == null || !_runBox!.isOpen) {
      _runBox = await Hive.openBox(AppConstants.runBoxName);
    }
    return _runBox!;
  }

  Future<void> saveRun(RunHistoryModel run) async {
    try {
      final box = await _getBox();
      await box.put(run.id, run.toJson());
    } catch (e) {
      throw StorageFailure(e.toString());
    }
  }

  Future<List<RunHistoryModel>> getAllRuns() async {
    try {
      final box = await _getBox();
      final runs = <RunHistoryModel>[];
      for (var key in box.keys) {
        final data = box.get(key);
        if (data != null) {
          runs.add(RunHistoryModel.fromJson(Map<String, dynamic>.from(data)));
        }
      }
      runs.sort((a, b) => b.date.compareTo(a.date));
      return runs;
    } catch (e) {
      throw StorageFailure(e.toString());
    }
  }

  Future<void> deleteRun(String id) async {
    try {
      final box = await _getBox();
      await box.delete(id);
    } catch (e) {
      throw StorageFailure(e.toString());
    }
  }
}