import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import '../services/widget_service.dart';
import '../widgets/habit_progress_widget.dart';
import '../widgets/habit_completion_toggle.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  final HabitService habitService;
  final WidgetService widgetService;

  const HomeScreen({
    super.key,
    required this.habitService,
    required this.widgetService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProgressViewType _viewType = ProgressViewType.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: [
          // Toggle view type
          IconButton(
            icon: Icon(
              _viewType == ProgressViewType.week
                  ? Icons.calendar_view_week
                  : Icons.calendar_month,
            ),
            onPressed: () {
              setState(() {
                _viewType = _viewType == ProgressViewType.week
                    ? ProgressViewType.month
                    : ProgressViewType.week;
              });
            },
            tooltip: _viewType == ProgressViewType.week
                ? 'Switch to Monthly'
                : 'Switch to Weekly',
          ),
          // Theme toggle (if needed)
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.habitService.getBox().listenable(),
        builder: (context, Box<Habit> box, _) {
          final habits = box.values.toList();

          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.track_changes,
                    size: 80,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No habits yet',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first habit',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _HabitCard(
                  habit: habit,
                  viewType: _viewType,
                  onDelete: () => _deleteHabit(habit),
                  onToggle: () {
                    setState(() {});
                    widget.widgetService.updateWidgets();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addHabit(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addHabit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHabitScreen(habitService: widget.habitService),
      ),
    );
    if (result == true) {
      setState(() {});
      widget.widgetService.updateWidgets();
    }
  }

  Future<void> _deleteHabit(Habit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.habitService.deleteHabit(habit.id);
      widget.widgetService.updateWidgets();
    }
  }
}

class _HabitCard extends StatelessWidget {
  final Habit habit;
  final ProgressViewType viewType;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _HabitCard({
    required this.habit,
    required this.viewType,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with icon, name, and toggle
            Row(
              children: [
                // Habit icon
                Icon(
                  IconData(
                    habit.iconCodePoint,
                    fontFamily: habit.iconFontFamily,
                  ),
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                // Habit name
                Expanded(
                  child: Text(habit.name, style: theme.textTheme.titleMedium),
                ),
                // Completion toggle for today
                HabitCompletionToggle(habit: habit, onToggle: onToggle),
                const SizedBox(width: 8),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  color: theme.colorScheme.secondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress visualization
            HabitProgressWidget(habit: habit, viewType: viewType),
            const SizedBox(height: 12),
            // Stats row
            Row(
              children: [
                _StatChip(
                  icon: Icons.local_fire_department,
                  label: '${habit.getCurrentStreak()} day streak',
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.percent,
                  label:
                      '${(habit.getCompletionRate(viewType == ProgressViewType.week ? 7 : 30) * 100).toStringAsFixed(0)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.secondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
