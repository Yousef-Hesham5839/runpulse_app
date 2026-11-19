class FitnessCalculators {
  static String formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final hStr = hours.toString().padLeft(2, '0');
      return '$hStr:$mStr:$sStr';
    }
    return '$mStr:$sStr';
  }


  static String calculatePace(double distanceInKm, int durationInSeconds) {
    if (distanceInKm <= 0.05 || durationInSeconds == 0) {
      return "--'--\"";
    }

    final totalMinutes = durationInSeconds / 60.0;
    final paceDecimal = totalMinutes / distanceInKm;

    final paceMinutes = paceDecimal.toInt();
    final paceSeconds = ((paceDecimal - paceMinutes) * 60).round();

    if (paceMinutes > 30) return "--'--\"";

    return "$paceMinutes'${paceSeconds.toString().padLeft(2, '0')}\"";
  }

  static int calculateCalories(double distanceInKm) {
    return (distanceInKm * 65).round();
  }
}