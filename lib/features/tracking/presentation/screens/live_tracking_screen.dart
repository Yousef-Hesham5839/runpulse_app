import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../history/domain/entities/run_history_entity.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/screens/history_screen.dart';
import '../../../history/presentation/widgets/run_summary_dialog.dart';
import '../../domain/entities/active_run_entity.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../widgets/live_map_widget.dart';
import '../widgets/metrics_hud_widget.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TrackingBloc>().add(InitLocationEvent());
  }

  void _showSummaryAndSave(BuildContext context, ActiveRunEntity run) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => RunSummaryDialog(
        run: run,
        onDiscard: () {
          Navigator.pop(dialogCtx);
          context.read<TrackingBloc>().add(ResetRunEvent());
        },
        onSave: () {
          final historyEntity = RunHistoryEntity(
            id: const Uuid().v4(),
            date: DateTime.now(),
            distanceInMeters: run.distanceInMeters,
            durationInSeconds: run.durationInSeconds,
            calories: run.caloriesBurned,
            routePoints: run.routePoints,
          );

          context.read<HistoryBloc>().add(SaveRunEvent(historyEntity));
          Navigator.pop(dialogCtx);
          context.read<TrackingBloc>().add(ResetRunEvent());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout saved to local history! 🏃‍♂️⚡'),
              backgroundColor: AppTheme.surface,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: BlocConsumer<TrackingBloc, TrackingState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppTheme.accentRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final run = state.activeRun;
          final isRunning = run.status == RunStatus.running;
          final isPaused = run.status == RunStatus.paused;
          final hasStarted = isRunning || isPaused;

          return Stack(
            children: [
              Positioned.fill(
                child: LiveMapWidget(
                  currentLocation: state.currentLocation,
                  routePoints: run.routePoints,
                  isTracking: hasStarted,
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.surface.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isRunning
                                      ? AppTheme.primaryVolt
                                      : (isPaused ? Colors.amber : Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isRunning
                                    ? 'RECORDING GPS'
                                    : (isPaused ? 'PAUSED' : 'READY TO RUN'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        FloatingActionButton.small(
                          heroTag: 'history_btn',
                          backgroundColor: AppTheme.surface.withOpacity(0.92),
                          foregroundColor: AppTheme.primaryVolt,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            );
                          },
                          child: const Icon(Icons.history_rounded, size: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 16,
                right: 16,
                bottom: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MetricsHudWidget(activeRun: run),
                        const SizedBox(height: 14),
                        _buildControlButtons(context, run),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context, ActiveRunEntity run) {
    final bloc = context.read<TrackingBloc>();

    if (run.status == RunStatus.initial || run.status == RunStatus.stopped) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryVolt,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            shadowColor: AppTheme.primaryVolt.withOpacity(0.5),
          ),
          onPressed: () => bloc.add(StartRunEvent()),
          icon: const Icon(Icons.play_arrow_rounded, size: 28),
          label: const Text(
            'START RUN',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
      );
    }

    if (run.status == RunStatus.running) {
      return Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: 'PAUSE',
              icon: Icons.pause_rounded,
              color: AppTheme.surface,
              textColor: Colors.amber,
              onTap: () => bloc.add(PauseRunEvent()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              label: 'STOP',
              icon: Icons.stop_rounded,
              color: AppTheme.accentRed,
              textColor: Colors.white,
              onTap: () {
                bloc.add(StopRunEvent());
                _showSummaryAndSave(context, run);
              },
            ),
          ),
        ],
      );
    }

    // RunStatus.paused
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: 'RESUME',
            icon: Icons.play_arrow_rounded,
            color: AppTheme.primaryVolt,
            textColor: Colors.black,
            onTap: () => bloc.add(ResumeRunEvent()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            label: 'FINISH',
            icon: Icons.flag_rounded,
            color: AppTheme.accentRed,
            textColor: Colors.white,
            onTap: () {
              bloc.add(StopRunEvent());
              _showSummaryAndSave(context, run);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 6,
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 22),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}