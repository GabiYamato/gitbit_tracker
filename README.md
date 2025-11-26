# GitBit Tracker - Minimalist Habit Tracker

A beautiful, minimalist habit tracking app built with Flutter, featuring GitHub-style contribution graphs and home screen widgets.

## Features

### 📱 Core Functionality
- **Add/Delete Habits**: Easily manage your daily habits
- **Material Icons**: Choose from 30+ Material Icons to represent your habits
- **Daily Progress Tracking**: Mark habits as complete/incomplete each day
- **GitHub-Style Visualization**: View your progress with contribution graph-style blocks
- **Flexible Views**: Switch between 7-day and 30-day progress views
- **Streak Tracking**: See your current streak for each habit
- **Completion Rate**: View percentage completion for weekly or monthly periods

### 🎨 Design
- **Minimalist UI**: Clean, distraction-free interface
- **Light Mode**: White background with soft neutral palette
- **Dark Mode**: Pure black background for OLED displays
- **No Emojis**: Professional Material Icons only
- **Smooth Animations**: Delightful micro-interactions

### 💾 Data Persistence
- **Local Storage**: All data stored locally using Hive
- **Fast & Efficient**: Optimized for performance
- **Privacy-First**: No cloud sync, your data stays on your device

### 📲 Home Screen Widgets
- **iOS Widgets**: Small, Medium, and Large sizes with WidgetKit
- **Android Widgets**: Resizable home screen widgets
- **Live Updates**: Widgets update automatically when habits change
- **Quick Actions**: View progress at a glance without opening the app

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── habit.dart                     # Habit data model with Hive annotations
│   └── habit.g.dart                   # Generated Hive type adapter
├── screens/
│   ├── home_screen.dart               # Main habit list screen
│   └── add_habit_screen.dart          # Add new habit screen
├── widgets/
│   ├── habit_progress_widget.dart     # GitHub-style progress visualization
│   └── habit_completion_toggle.dart   # Checkbox for daily completion
├── services/
│   ├── habit_service.dart             # Habit CRUD operations
│   └── widget_service.dart            # Home screen widget management
└── themes/
    └── app_theme.dart                 # Centralized theme configuration
```

### iOS Widget Files
```
ios/
├── HabitWidget/
│   ├── HabitWidget.swift              # iOS widget implementation
│   └── Info.plist                     # Widget configuration
└── Runner/
    └── Runner.entitlements            # App Groups configuration
```

### Android Widget Files
```
android/app/src/main/
├── kotlin/com/example/gitbit_tracker/widget/
│   └── HabitWidgetProvider.kt         # Android widget provider
└── res/
    ├── layout/
    │   ├── habit_widget.xml           # Widget layout
    │   └── habit_item.xml             # Habit item layout
    └── xml/
        └── habit_widget_info.xml      # Widget metadata
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.9.0 or higher)

### Installation

1. **Clone the repository** or navigate to the project directory:
   ```bash
   cd /path/to/gitbit_tracker
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

### Setting Up Widgets

**For detailed widget setup instructions, see:**
- **[WIDGET_QUICK_START.md](WIDGET_QUICK_START.md)** - Quick setup guide
- **[WIDGET_SETUP.md](WIDGET_SETUP.md)** - Complete configuration guide

**Quick iOS Setup:**
```bash
cd ios
open Runner.xcworkspace
# Follow steps in WIDGET_QUICK_START.md
```

**Android widgets** are already configured and ready to use!

### Running Tests
```bash
flutter test
```

## Customizing Themes

All theme configuration is centralized in `lib/themes/app_theme.dart`. You can easily customize:

### Colors
```dart
// Light Theme Colors
static const Color lightBackground = Color(0xFFFFFFFF);
static const Color lightPrimary = Color(0xFF1A1A1A);
// ... modify as needed

// Dark Theme Colors
static const Color darkBackground = Color(0xFF000000);
static const Color darkPrimary = Color(0xFFFFFFFF);
// ... modify as needed

// Progress Colors (GitHub-style)
static const Color progressLevel1 = Color(0xFF9BE9A8);
static const Color progressLevel2 = Color(0xFF40C463);
// ... customize your gradient
```

### Typography
```dart
static const TextStyle headlineLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w700,
  letterSpacing: -0.5,
);
// ... modify text styles
```

### Component Styles
- Card borders and radius
- Button styles
- Input field appearance
- Icon sizes
- Dialog styles

## Usage

### Adding a Habit
1. Tap the **+** floating action button
2. Enter a habit name
3. Choose a Material Icon from the grid
4. Tap **Create Habit**

### Tracking Progress
- Tap the checkbox next to any habit to mark it complete for today
- View your progress with the GitHub-style contribution graph
- Toggle between weekly (7 days) and monthly (30 days) views using the calendar icon

### Viewing Statistics
Each habit card displays:
- 🔥 **Current Streak**: Consecutive days completed
- 📊 **Completion Rate**: Percentage for the selected period

### Deleting a Habit
Tap the delete icon on any habit card and confirm deletion.

### Using Home Screen Widgets

#### iOS Widgets
1. **Add widget to home screen**:
   - Long press on home screen
   - Tap the `+` button
   - Search for "Habit Tracker"
   - Choose size (Small, Medium, Large)
   - Add to Home Screen

2. **Widget Sizes**:
   - **Small**: Single habit with 7-day progress
   - **Medium**: 3 habits with progress bars
   - **Large**: 6 habits with full details

#### Android Widgets
1. **Add widget to home screen**:
   - Long press on home screen
   - Tap "Widgets"
   - Find "Habit Tracker"
   - Drag to home screen

2. **Features**:
   - Resizable widget
   - Shows multiple habits
   - Updates every 15 minutes

## Widget Configuration

For complete widget setup instructions, see:
- **[WIDGET_QUICK_START.md](WIDGET_QUICK_START.md)** - Step-by-step quick guide
- **[WIDGET_SETUP.md](WIDGET_SETUP.md)** - Detailed configuration and troubleshooting

## Dependencies

```yaml
dependencies:
  flutter: sdk
  hive: ^2.2.3              # Fast key-value database
  hive_flutter: ^1.1.0      # Flutter extensions for Hive
  home_widget: ^0.6.0       # Home screen widgets
  path_provider: ^2.1.1     # Path utilities
  intl: ^0.19.0             # Internationalization

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0
  hive_generator: ^2.0.1    # Code generation for Hive
  build_runner: ^2.4.7      # Build system
```

## Architecture

### Data Flow
1. **HabitService** manages all CRUD operations via Hive
2. **ValueListenableBuilder** automatically updates UI when data changes
3. **Habit Model** extends HiveObject for automatic persistence
4. All habit operations (toggle, streak calculation) are methods on the Habit class

### State Management
- Uses Flutter's built-in `ValueListenableBuilder` with Hive's reactive boxes
- Minimal boilerplate, maximum efficiency
- No external state management libraries needed

## Performance Optimizations

- **Lazy Loading**: Only visible widgets are rendered
- **Efficient Updates**: ValueListenableBuilder minimizes rebuilds
- **Local Storage**: No network calls, instant data access
- **Optimized Rendering**: Minimal widget tree depth

## Contributing

This is a personal project, but suggestions and improvements are welcome!

## License

This project is created for educational purposes.

## Acknowledgments

- GitHub for the contribution graph inspiration
- Flutter team for the amazing framework
- Material Design for the icon library
