import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../tracking/domain/entities/active_run_entity.dart';

class RunSummaryDialog extends StatelessWidget {
  final ActiveRunEntity run;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const RunSummaryDialog({
    super.key,
    required this.run,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryVolt.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                size: 48,
                color: AppTheme.primaryVolt,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'WORKOUT COMPLETED! 🎉',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Great job! Here is your performance summary:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),

            // كارت تفاصيل المؤشرات
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    label: 'DISTANCE',
                    value: '${run.distanceInKm.toStringAsFixed(2)} KM',
                    valueColor: AppTheme.primaryVolt,
                  ),
                  const Divider(height: 20, color: Colors.white10),
                  _buildSummaryRow(
                    label: 'TOTAL TIME',
                    value: run.formattedDuration,
                    valueColor: Colors.white,
                  ),
                  const Divider(height: 20, color: Colors.white10),
                  _buildSummaryRow(
                    label: 'AVG PACE',
                    value: '${run.formattedPace} /KM',
                    valueColor: AppTheme.secondaryCyan,
                  ),
                  const Divider(height: 20, color: Colors.white10),
                  _buildSummaryRow(
                    label: 'CALORIES BURNED',
                    value: '${run.caloriesBurned} KCAL',
                    valueColor: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onDiscard,
                    child: const Text(
                      'DISCARD',
                      style: TextStyle(
                        color: AppTheme.accentRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryVolt,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: onSave,
                    child: const Text(
                      'SAVE RUN 💾',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}