import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'services/habit_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final habitService = HabitService();
  await habitService.init();

  runApp(MyApp(habitService: habitService));
}

class MyApp extends StatefulWidget {
  final HabitService habitService;

  const MyApp({super.key, required this.habitService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(habitService: widget.habitService),
    );
  }
}
