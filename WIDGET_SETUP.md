# Home Screen Widget Configuration Guide

## Overview

This guide explains how to configure and use the home screen widgets for iOS and Android.

## iOS Widget Setup

### Prerequisites
- Xcode 14.0 or later
- iOS 14.0 or later
- Valid Apple Developer account (for testing on device)

### Adding Widget Extension to Xcode

1. **Open the iOS project in Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Add Widget Extension**:
   - Click on the project in the navigator
   - Click the `+` button at the bottom of the targets list
   - Select "Widget Extension"
   - Name it: `HabitWidget`
   - Product Name: `HabitWidget`
   - Uncheck "Include Configuration Intent"
   - Click Finish

3. **Replace the generated files**:
   - Delete the auto-generated `HabitWidget.swift` and `Info.plist`
   - Use the files already created in `ios/HabitWidget/`

4. **Configure App Groups**:
   - Select the main "Runner" target
   - Go to "Signing & Capabilities"
   - Click "+ Capability" and add "App Groups"
   - Add group: `group.com.example.gitbittracker`
   - Select the "HabitWidget" target
   - Repeat: Add "App Groups" capability
   - Add the same group: `group.com.example.gitbittracker`

5. **Configure Runner.entitlements**:
   - The file `ios/Runner/Runner.entitlements` has been created
   - Make sure it's included in your Runner target:
     - Select Runner target → Build Phases → Copy Bundle Resources
     - If not listed, add Runner.entitlements

6. **Update Bundle Identifiers**:
   - Runner target: `com.example.gitbittracker`
   - HabitWidget target: `com.example.gitbittracker.HabitWidget`

### Testing iOS Widget

1. **Build and run** the app on a simulator or device
2. **Add widget to home screen**:
   - Long press on the home screen
   - Tap the `+` button in the top left
   - Search for "Habit Tracker"
   - Select your desired widget size (Small, Medium, or Large)
   - Add to Home Screen

### iOS Widget Sizes

- **Small (2x2)**: Single habit with progress and streak
- **Medium (4x2)**: Up to 3 habits with progress bars
- **Large (4x4)**: Up to 6 habits with full details

## Android Widget Setup

### Prerequisites
- Android Studio
- Android 8.0 (API 26) or later

### Files Already Created

The following Android widget files have been created:

1. **Layout Files** (`android/app/src/main/res/layout/`):
   - `habit_widget.xml` - Main widget layout
   - `habit_item.xml` - Individual habit item layout

2. **Widget Configuration** (`android/app/src/main/res/xml/`):
   - `habit_widget_info.xml` - Widget provider configuration

3. **Widget Provider** (`android/app/src/main/kotlin/.../widget/`):
   - `HabitWidgetProvider.kt` - Widget logic

4. **Resources** (`android/app/src/main/res/values/`):
   - `strings.xml` - String resources

### AndroidManifest.xml

The widget receiver has been registered in `AndroidManifest.xml`:

```xml
<receiver
    android:name=".widget.HabitWidgetProvider"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/habit_widget_info" />
</receiver>
```

### Testing Android Widget

1. **Build and run** the app:
   ```bash
   flutter run
   ```

2. **Add widget to home screen**:
   - Long press on the home screen
   - Tap "Widgets"
   - Find "Habit Tracker"
   - Long press and drag to home screen
   - Release to place

## Widget Features

### Small Widget (iOS) / Compact Widget (Android)
- Shows first habit
- Displays 7-day progress bar
- Shows current streak
- Tap to toggle completion

### Medium Widget (iOS/Android)
- Shows 3 habits
- Each with progress visualization
- GitHub-style contribution squares
- Interactive checkboxes

### Large Widget (iOS)
- Shows up to 6 habits
- Full progress details
- Streak counters
- Completion percentages

## Widget Data Flow

1. **App updates data** → Habit completion changes
2. **WidgetService.updateWidgets()** → Saves data to shared storage
3. **Widget reads data** → From UserDefaults (iOS) / SharedPreferences (Android)
4. **Widget UI updates** → Shows current habit status

### Data Storage

#### iOS
- Uses **UserDefaults** with App Group: `group.com.example.gitbittracker`
- Data keys:
  - `habit_count`: Number of habits
  - `habit_X_id`, `habit_X_name`, `habit_X_icon`: Habit details
  - `habit_X_day_Y`: Completion status for day Y
  - `habit_X_completed_today`: Today's completion

#### Android
- Uses **SharedPreferences** via `home_widget` plugin
- Same key structure as iOS

## Widget Interactions

### iOS
- Tap widget → Deep link to app: `habittracker://toggle?habitId=<ID>`
- Handled by `WidgetService.backgroundCallback()`

### Android
- Tap checkbox → Triggers widget update
- Deep link support (requires additional setup)

## Troubleshooting

### iOS

**Widget not showing data:**
1. Check App Groups are configured correctly
2. Verify group name matches: `group.com.example.gitbittracker`
3. Ensure both Runner and HabitWidget targets have the capability

**Widget not updating:**
1. Check `WidgetService.updateWidgets()` is called after habit changes
2. Verify `HomeWidget.updateWidget()` is being called
3. Try removing and re-adding the widget

**Build errors:**
1. Clean build folder: Product → Clean Build Folder
2. Delete derived data
3. Restart Xcode

### Android

**Widget not appearing in widget list:**
1. Check `AndroidManifest.xml` has widget receiver registered
2. Verify `habit_widget_info.xml` exists in `res/xml/`
3. Rebuild the app

**Widget shows "No habits":**
1. Verify `home_widget` plugin is properly configured
2. Check SharedPreferences data is being saved
3. Add some habits in the app and wait for update

**Widget not updating:**
1. Check `WidgetService.updateWidgets()` is called
2. Verify `updatePeriodMillis` in `habit_widget_info.xml`
3. Force update by removing and re-adding widget

## Customization

### Changing Update Frequency

**iOS** (in `HabitWidget.swift`):
```swift
// Update every 15 minutes
let nextUpdate = Calendar.current.date(
    byAdding: .minute, 
    value: 15, 
    to: currentDate
)!
```

**Android** (in `habit_widget_info.xml`):
```xml
<!-- Update every 15 minutes (900000 ms) -->
android:updatePeriodMillis="900000"
```

### Changing Widget Colors

**iOS**: Edit `HabitWidget.swift`
- Progress color: `.green` → `.blue`, `.orange`, etc.
- Background: Add `.background(Color.white)`

**Android**: Create color resources in `res/values/colors.xml`
```xml
<color name="progress_completed">#4CAF50</color>
<color name="progress_empty">#E0E0E0</color>
```

### Widget Sizes

**iOS**: Modify in `HabitWidget.swift`
```swift
.supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
```

**Android**: Modify in `habit_widget_info.xml`
```xml
android:minWidth="180dp"
android:minHeight="110dp"
```

## Advanced Features (Future Enhancements)

### Interactive Widgets (iOS 17+)
- Enable checkbox toggling directly from widget
- No need to open app

### Dynamic Widget Updates
- Real-time updates when habits change
- Push notifications to update widgets

### Widget Collections
- Multiple widget variants
- Different layouts for different use cases

### Custom Widget Configuration
- User-selectable habits to display
- Customizable colors and themes

## Production Deployment

### iOS

1. **Update Bundle Identifiers**:
   - Change `com.example.gitbittracker` to your app ID
   - Update App Group to `group.YOUR_TEAM_ID.gitbittracker`

2. **Signing**:
   - Configure signing for both Runner and HabitWidget targets
   - Ensure App Groups entitlement is enabled

3. **Archive and Submit**:
   - Archive includes both app and widget extension
   - Widget will be available automatically

### Android

1. **Update Package Name**:
   - Change `com.example.gitbit_tracker` throughout
   - Update in `build.gradle`, `AndroidManifest.xml`, Kotlin files

2. **Build Release**:
   ```bash
   flutter build apk --release
   # or
   flutter build appbundle --release
   ```

3. **Widget is included** in the APK/AAB automatically

## Resources

- [iOS WidgetKit Documentation](https://developer.apple.com/documentation/widgetkit)
- [Android App Widgets Guide](https://developer.android.com/develop/ui/views/appwidgets)
- [home_widget Plugin](https://pub.dev/packages/home_widget)
- [Flutter Widget Documentation](https://docs.flutter.dev/development/platform-integration/platform-views)

## Support

For issues or questions:
1. Check the Troubleshooting section
2. Review the home_widget plugin documentation
3. Check platform-specific documentation (iOS/Android)
