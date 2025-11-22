# Quick Start Guide

## Run the App

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate code** (for Hive type adapters):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Try It Out

1. **Add your first habit**:
   - Tap the + button
   - Enter "Morning Run"
   - Select the running person icon
   - Tap "Create Habit"

2. **Mark it complete**:
   - Tap the checkbox next to your habit
   - Watch the progress square light up!

3. **Switch views**:
   - Tap the calendar icon in the top-right
   - Toggle between 7-day and 30-day views

4. **Build a streak**:
   - Come back daily and check off your habits
   - Watch your streak counter grow!

## Customization

### Change Theme Colors

Edit `lib/themes/app_theme.dart`:

```dart
// Example: Change progress colors
static const Color progressLevel3 = Color(0xFF30A14E); // GitHub green
// Change to:
static const Color progressLevel3 = Color(0xFF2196F3); // Blue
```

### Add More Icon Options

Edit `lib/screens/add_habit_screen.dart`:

```dart
final List<IconData> _popularIcons = [
  Icons.star,
  Icons.fitness_center,
  Icons.book,
  // Add your icons here:
  Icons.laptop,
  Icons.phone,
  // ...
];
```

## Troubleshooting

### "Target of URI hasn't been generated" Error

Run the code generator:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### App Not Saving Data

Make sure Hive is initialized in `main.dart`:
```dart
final habitService = HabitService();
await habitService.init();
```

### Theme Not Applying

Check that you're passing both light and dark themes:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: _themeMode,
)
```

## Next Steps

- Add more habits and build consistency
- Try switching between light and dark modes
- Explore the GitHub-style progress visualization
- Customize colors and icons to your preference

Enjoy tracking your habits! 🎯
