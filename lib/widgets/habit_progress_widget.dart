import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../themes/app_theme.dart';

enum ProgressViewType { week, month }

class HabitProgressWidget extends StatelessWidget {
  final Habit habit;
  final ProgressViewType viewType;

  const HabitProgressWidget({
    super.key,
    required this.habit,
    this.viewType = ProgressViewType.week,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = viewType == ProgressViewType.week ? 7 : 30;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days, (index) {
        final date = DateTime.now().subtract(Duration(days: days - 1 - index));
        final isCompleted = habit.isCompletedOnDate(date);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < days - 1 ? 4 : 0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.getProgressColor(isDark, isCompleted),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class CompactHabitProgressWidget extends StatelessWidget {
  final Habit habit;
  final int days;

  const CompactHabitProgressWidget({
    super.key,
    required this.habit,
    this.days = 7,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 20,
      child: Row(
        children: List.generate(days, (index) {
          final date = DateTime.now().subtract(
            Duration(days: days - 1 - index),
          );
          final isCompleted = habit.isCompletedOnDate(date);

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index < days - 1 ? 2 : 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.getProgressColor(isDark, isCompleted),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
