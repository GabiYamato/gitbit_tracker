# Project File Structure

## Core Application Files

### Main Entry Point
- **`lib/main.dart`**
  - Initializes Hive database
  - Sets up theme configuration
  - Creates HabitService instance
  - Launches HomeScreen

### Models
- **`lib/models/habit.dart`**
  - Habit data model with Hive annotations
  - Methods: `toggleCompletion()`, `isCompletedOnDate()`, `getCurrentStreak()`, `getCompletionRate()`
  - Fields: id, name, iconCodePoint, iconFontFamily, createdAt, completionHistory
- **`lib/models/habit.g.dart`** (auto-generated)
  - Hive TypeAdapter for Habit serialization

### Screens
- **`lib/screens/home_screen.dart`**
  - Main habit list view
  - Shows all habits with progress visualization
  - Toggle between weekly/monthly views
  - Delete habit functionality
- **`lib/screens/add_habit_screen.dart`**
  - Create new habit screen
  - Name input field
  - Icon selector grid (30+ Material Icons)
  - Form validation

### Widgets
- **`lib/widgets/habit_progress_widget.dart`**
  - `HabitProgressWidget`: Full-width GitHub-style progress bars
  - `CompactHabitProgressWidget`: Smaller version for compact views
  - Supports both 7-day and 30-day views
  - Dynamic color based on completion status
- **`lib/widgets/habit_completion_toggle.dart`**
  - Animated checkbox for daily completion
  - Toggles habit completion for current day
  - Visual feedback on tap

### Services
- **`lib/services/habit_service.dart`**
  - Hive database management
  - CRUD operations: `addHabit()`, `updateHabit()`, `deleteHabit()`, `getAllHabits()`
  - Reactive updates via `watchHabits()` stream
  - Box management for ValueListenableBuilder

### Themes
- **`lib/themes/app_theme.dart`**
  - **Centralized theme configuration**
  - Light theme: white background, neutral palette
  - Dark theme: pure black background
  - Typography styles
  - Component themes (cards, buttons, inputs, dialogs)
  - Progress colors (GitHub-style green gradient)
  - Helper methods for color selection

## Configuration Files

- **`pubspec.yaml`**: Dependencies and project configuration
- **`analysis_options.yaml`**: Dart linter rules
- **`.gitignore`**: Git ignore patterns
- **`.metadata`**: Flutter project metadata

## Platform-Specific Files

### Android
- `android/app/src/main/AndroidManifest.xml`
- `android/app/build.gradle.kts`
- `android/app/src/main/kotlin/.../MainActivity.kt`

### iOS
- `ios/Runner/Info.plist`
- `ios/Runner/AppDelegate.swift`
- `ios/Runner.xcodeproj/`

### macOS
- `macos/Runner/Info.plist`
- `macos/Runner/AppDelegate.swift`

### Web
- `web/index.html`
- `web/manifest.json`

### Linux
- `linux/runner/main.cc`
- `linux/CMakeLists.txt`

### Windows
- `windows/runner/main.cpp`
- `windows/CMakeLists.txt`

## Testing

- **`test/widget_test.dart`**: Basic widget tests

## Documentation

- **`README.md`**: Comprehensive project documentation
- **`QUICKSTART.md`**: Quick start guide
- **`STRUCTURE.md`**: This file - project structure overview

## Generated Files (Git-ignored)

- `.dart_tool/`: Dart tooling cache
- `build/`: Build outputs
- `lib/models/habit.g.dart`: Hive type adapter (regenerate with build_runner)
- `.flutter-plugins-dependencies`: Plugin metadata

## Key Architecture Decisions

### Why Hive?
- Fast, lightweight local database
- No boilerplate compared to SQLite
- Reactive updates with ValueListenableBuilder
- Type-safe with code generation

### Why No State Management Library?
- Hive's reactive boxes work seamlessly with ValueListenableBuilder
- Simple app doesn't need complex state management
- Less boilerplate, more maintainable

### Why Material Icons Only?
- Consistent, professional appearance
- No emoji rendering issues across platforms
- Large selection (30+ common icons included)
- Matches minimalist design philosophy

### Theme Architecture
- Single source of truth in `app_theme.dart`
- Easy to modify all colors/styles from one place
- Supports both light and dark modes
- Pure black dark mode for OLED displays

## Extending the App

### Adding New Icons
Edit `lib/screens/add_habit_screen.dart` and add to `_popularIcons` list

### Changing Theme Colors
Edit `lib/themes/app_theme.dart` color constants

### Adding New Habit Properties
1. Add field to `lib/models/habit.dart`
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Update UI screens to display new property

### Implementing Cloud Sync
1. Add Firebase/Supabase package
2. Create sync service
3. Update HabitService to sync with cloud
4. Handle conflict resolution

### Adding Reminders
1. Add `flutter_local_notifications` package
2. Create notification service
3. Add reminder time to Habit model
4. Schedule daily notifications

## Build Commands

```bash
# Get dependencies
flutter pub get

# Generate code (Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Build for release (Android)
flutter build apk --release

# Build for release (iOS)
flutter build ios --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .
```
