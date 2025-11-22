import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCompletionToggle extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onToggle;

  const HabitCompletionToggle({super.key, required this.habit, this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedOnDate(DateTime.now());
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        habit.toggleCompletion(DateTime.now());
        onToggle?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCompleted
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          border: Border.all(
            color: isCompleted
                ? theme.colorScheme.primary
                : theme.dividerTheme.color ?? Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: isCompleted
            ? Icon(Icons.check, size: 20, color: theme.colorScheme.onPrimary)
            : null,
      ),
    );
  }
}
