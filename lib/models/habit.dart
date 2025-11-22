import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int iconCodePoint;

  @HiveField(3)
  String iconFontFamily;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  Map<String, bool> completionHistory; // Date string (YYYY-MM-DD) -> completed

  Habit({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.createdAt,
    Map<String, bool>? completionHistory,
  }) : completionHistory = completionHistory ?? {};

  // Check if habit is completed for a specific date
  bool isCompletedOnDate(DateTime date) {
    final dateKey = _formatDate(date);
    return completionHistory[dateKey] ?? false;
  }

  // Toggle completion for a specific date
  void toggleCompletion(DateTime date) {
    final dateKey = _formatDate(date);
    completionHistory[dateKey] = !(completionHistory[dateKey] ?? false);
    save(); // Save to Hive
  }

  // Set completion for a specific date
  void setCompletion(DateTime date, bool isCompleted) {
    final dateKey = _formatDate(date);
    completionHistory[dateKey] = isCompleted;
    save(); // Save to Hive
  }

  // Get completion rate for the last N days
  double getCompletionRate(int days) {
    if (days <= 0) return 0.0;

    int completed = 0;
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      if (isCompletedOnDate(date)) {
        completed++;
      }
    }

    return completed / days;
  }

  // Get current streak
  int getCurrentStreak() {
    int streak = 0;
    final now = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      if (isCompletedOnDate(date)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // Helper to format date as string
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Copy with method
  Habit copyWith({
    String? id,
    String? name,
    int? iconCodePoint,
    String? iconFontFamily,
    DateTime? createdAt,
    Map<String, bool>? completionHistory,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      createdAt: createdAt ?? this.createdAt,
      completionHistory: completionHistory ?? Map.from(this.completionHistory),
    );
  }
}
