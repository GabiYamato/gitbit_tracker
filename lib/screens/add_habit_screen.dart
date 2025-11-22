import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class AddHabitScreen extends StatefulWidget {
  final HabitService habitService;

  const AddHabitScreen({super.key, required this.habitService});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  IconData _selectedIcon = Icons.star;

  // Popular Material Icons for habits
  final List<IconData> _popularIcons = [
    Icons.star,
    Icons.fitness_center,
    Icons.book,
    Icons.water_drop,
    Icons.self_improvement,
    Icons.directions_run,
    Icons.local_cafe,
    Icons.nightlight,
    Icons.wb_sunny,
    Icons.restaurant,
    Icons.music_note,
    Icons.brush,
    Icons.code,
    Icons.shopping_cart,
    Icons.home,
    Icons.work,
    Icons.school,
    Icons.favorite,
    Icons.pets,
    Icons.spa,
    Icons.science,
    Icons.sports_basketball,
    Icons.headphones,
    Icons.camera_alt,
    Icons.emoji_events,
    Icons.medical_services,
    Icons.nature,
    Icons.psychology,
    Icons.theater_comedy,
    Icons.volunteer_activism,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Habit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g., Morning Run',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a habit name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Icon selection
            Text(
              'Choose an Icon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Icon grid
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerTheme.color ?? Colors.grey,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _popularIcons.length,
                itemBuilder: (context, index) {
                  final icon = _popularIcons[index];
                  final isSelected = icon == _selectedIcon;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerTheme.color ??
                                    Colors.grey,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _saveHabit,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Create Habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        iconCodePoint: _selectedIcon.codePoint,
        iconFontFamily: _selectedIcon.fontFamily ?? 'MaterialIcons',
        createdAt: DateTime.now(),
      );

      await widget.habitService.addHabit(habit);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }
}
