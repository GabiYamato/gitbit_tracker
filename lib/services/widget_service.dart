import 'package:home_widget/home_widget.dart';
import '../models/habit.dart';
import 'habit_service.dart';

class WidgetService {
  static const String appGroupId = 'group.com.example.gitbittracker';
  static const String widgetName = 'HabitWidget';

  final HabitService habitService;

  WidgetService(this.habitService);

  /// Initialize widget service
  Future<void> init() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  /// Update all widgets with current habit data
  Future<void> updateWidgets() async {
    final habits = habitService.getAllHabits();
    
    print('📱 Updating widgets with ${habits.length} habits');

    // Send data to widgets
    await _sendHabitData(habits);

    // Update widgets
    await HomeWidget.updateWidget(
      name: widgetName,
      iOSName: widgetName,
      androidName: widgetName,
    );
    
    print('✅ Widget update complete');
  }

  /// Send habit data to native widgets
  Future<void> _sendHabitData(List<Habit> habits) async {
    // Number of habits
    await HomeWidget.saveWidgetData<int>('habit_count', habits.length);
    print('📊 Saved habit_count: ${habits.length}');

    // Send each habit's data
    for (int i = 0; i < habits.length && i < 10; i++) {
      final habit = habits[i];
      final prefix = 'habit_$i';

      await HomeWidget.saveWidgetData<String>('${prefix}_id', habit.id);
      await HomeWidget.saveWidgetData<String>('${prefix}_name', habit.name);
      await HomeWidget.saveWidgetData<int>(
        '${prefix}_icon',
        habit.iconCodePoint,
      );
      await HomeWidget.saveWidgetData<int>(
        '${prefix}_streak',
        habit.getCurrentStreak(),
      );

      // Send last 7 days completion status
      for (int day = 0; day < 7; day++) {
        final date = DateTime.now().subtract(Duration(days: 6 - day));
        final isCompleted = habit.isCompletedOnDate(date);
        await HomeWidget.saveWidgetData<bool>(
          '${prefix}_day_$day',
          isCompleted,
        );
      }

      // Is completed today
      await HomeWidget.saveWidgetData<bool>(
        '${prefix}_completed_today',
        habit.isCompletedOnDate(DateTime.now()),
      );
      
      print('💾 Saved habit $i: ${habit.name} (streak: ${habit.getCurrentStreak()})');
    }
  }

  /// Toggle habit completion from widget
  Future<void> toggleHabitFromWidget(String habitId) async {
    final habit = habitService.getHabitById(habitId);
    if (habit != null) {
      habit.toggleCompletion(DateTime.now());
      await updateWidgets();
    }
  }

  /// Register widget callback for interactions
  void registerCallbacks() {
    HomeWidget.registerInteractivityCallback(backgroundCallback);
  }
}

/// Background callback for widget interactions
@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri == null) return;

  // Parse action from URI
  final action = uri.host;
  final habitId = uri.queryParameters['habitId'];

  if (action == 'toggle' && habitId != null) {
    // Initialize services
    final habitService = HabitService();
    await habitService.init();

    final widgetService = WidgetService(habitService);
    await widgetService.init();

    // Toggle habit
    await widgetService.toggleHabitFromWidget(habitId);
  }
}
