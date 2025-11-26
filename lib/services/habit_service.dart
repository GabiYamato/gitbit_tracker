import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class HabitService {
  static const String _boxName = 'habits';
  late Box<Habit> _habitBox;

  // Initialize Hive and open box
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    _habitBox = await Hive.openBox<Habit>(_boxName);
  }

  // Get all habits
  List<Habit> getAllHabits() {
    return _habitBox.values.toList();
  }

  // Get habit by ID
  Habit? getHabitById(String id) {
    try {
      return _habitBox.values.firstWhere((habit) => habit.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new habit
  Future<void> addHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
  }

  // Update habit
  Future<void> updateHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
  }

  // Delete habit
  Future<void> deleteHabit(String id) async {
    await _habitBox.delete(id);
  }

  // Toggle habit completion for today
  Future<void> toggleHabitToday(String id) async {
    final habit = getHabitById(id);
    if (habit != null) {
      habit.toggleCompletion(DateTime.now());
    }
  }

  // Listen to changes
  Stream<List<Habit>> watchHabits() {
    return _habitBox.watch().map((_) => getAllHabits());
  }

  // Get box for ValueListenableBuilder
  Box<Habit> getBox() {
    return _habitBox;
  }

  // Clear all habits (for testing)
  Future<void> clearAllHabits() async {
    await _habitBox.clear();
  }
}
