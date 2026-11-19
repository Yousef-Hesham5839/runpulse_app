import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/tracking/presentation/screens/live_tracking_screen.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // تهيئة قاعدة بيانات Hive المحلية
  await initDependencies();
  runApp(const RunPulseApp());
}

class RunPulseApp extends StatelessWidget {
  const RunPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TrackingBloc>()),
        BlocProvider(create: (_) => sl<HistoryBloc>()..add(LoadHistoryEvent())),
      ],
      child: MaterialApp(
        title: 'RunPulse',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const LiveTrackingScreen(),
      ),
    );
  }
}