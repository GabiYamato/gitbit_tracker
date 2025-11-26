# iOS Widget Quick Setup

## Step-by-Step Instructions

### 1. Open Xcode
```bash
cd ios
open Runner.xcworkspace
```

### 2. Add Widget Extension

1. Click on project name in navigator
2. At bottom of targets list, click `+` button
3. Select **"Widget Extension"**
4. Settings:
   - Product Name: `HabitWidget`
   - Uncheck "Include Configuration Intent"
   - Click **Finish**
   - When asked about scheme, click **Activate**

### 3. Replace Generated Files

Delete Xcode's auto-generated files and use ours:
- Delete `HabitWidget/HabitWidget.swift` (the one Xcode created)
- Delete `HabitWidget/Info.plist` (the one Xcode created)
- The correct files are already in `ios/HabitWidget/`

### 4. Add Files to Xcode

1. Right-click `HabitWidget` folder in Xcode
2. Select **"Add Files to Runner"**
3. Navigate to `ios/HabitWidget/`
4. Select both:
   - `HabitWidget.swift`
   - `Info.plist`
5. Make sure **"Copy items if needed"** is UNCHECKED
6. Target: **HabitWidget** (check it)
7. Click **Add**

### 5. Configure App Groups

**For Runner Target:**
1. Select **Runner** target
2. Go to **"Signing & Capabilities"** tab
3. Click **"+ Capability"**
4. Select **"App Groups"**
5. Click **"+"** under App Groups
6. Enter: `group.com.example.gitbittracker`
7. Click **OK**

**For HabitWidget Target:**
1. Select **HabitWidget** target
2. Go to **"Signing & Capabilities"** tab
3. Click **"+ Capability"**
4. Select **"App Groups"**
5. Check the same group: `group.com.example.gitbittracker`

### 6. Add Runner.entitlements

1. Select **Runner** target
2. Go to **"Build Settings"**
3. Search for "entitlements"
4. Under **"Code Signing Entitlements"**:
   - Set to: `Runner/Runner.entitlements`

### 7. Update Bundle Identifiers (if needed)

**Runner:**
- Bundle Identifier: `com.example.gitbittracker`

**HabitWidget:**
- Bundle Identifier: `com.example.gitbittracker.HabitWidget`

### 8. Build and Run

1. Select a device or simulator (iOS 14+)
2. Run the app: **Cmd+R**
3. Once running, go to home screen
4. Long press → Tap `+` → Search "Habit"
5. Add widget to home screen

## Troubleshooting

### "No such module 'WidgetKit'"
- Deployment target must be iOS 14.0+
- Check both Runner and HabitWidget targets

### Widget not showing
- Verify App Groups are configured in BOTH targets
- Check group name matches exactly
- Try clean build: **Shift+Cmd+K**

### Build errors
1. Clean: **Shift+Cmd+K**
2. Close Xcode
3. Delete `ios/Pods`, `ios/Podfile.lock`
4. Run: `cd ios && pod install`
5. Reopen Xcode

---

# Android Widget Quick Setup

## The Easy Way (Already Done!)

All Android widget files are already created and configured. Just:

1. **Build the app**:
   ```bash
   flutter run
   ```

2. **Add widget to home screen**:
   - Long press on home screen
   - Tap "Widgets"
   - Find "Habit Tracker"
   - Drag to home screen

## If You Need to Verify Setup

### Check Files Exist

```
android/app/src/main/
├── kotlin/com/example/gitbit_tracker/widget/
│   └── HabitWidgetProvider.kt         ✓
├── res/
│   ├── layout/
│   │   ├── habit_widget.xml           ✓
│   │   └── habit_item.xml             ✓
│   ├── xml/
│   │   └── habit_widget_info.xml      ✓
│   └── values/
│       └── strings.xml                ✓
└── AndroidManifest.xml                ✓
```

### Verify AndroidManifest.xml

Should have this inside `<application>`:

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

## Troubleshooting

### Widget doesn't appear in widget list
- Uninstall and reinstall the app
- Check `AndroidManifest.xml` has receiver
- Verify `habit_widget_info.xml` exists

### Widget shows blank/crashes
- Check logcat for errors
- Verify all layout files exist
- Rebuild: `flutter clean && flutter run`

---

# Testing Widgets

## iOS

1. Run app
2. Add a few habits
3. Go to home screen (Home button or swipe up)
4. Long press → `+` → "Habit Tracker"
5. Try all sizes: Small, Medium, Large
6. Toggle habits in app
7. Widget should update automatically

## Android

1. Run app
2. Add a few habits
3. Long press home screen → "Widgets"
4. Find "Habit Tracker"
5. Drag to home screen
6. Resize if needed
7. Toggle habits in app
8. Wait ~15 min or force update

---

# Quick Commands

```bash
# Run app
flutter run

# Clean build
flutter clean
flutter pub get

# iOS specific
cd ios
pod install
open Runner.xcworkspace

# Android specific
cd android
./gradlew clean

# Build release
flutter build ios --release
flutter build apk --release
```

---

# Common Issues

## iOS: "Provisioning profile doesn't include App Groups"
- You need a paid Apple Developer account
- Or test on simulator only

## Android: R.layout.habit_widget not found
- Run `flutter clean`
- Run `flutter pub get`
- Rebuild

## Widget not updating
- Check `WidgetService.updateWidgets()` is called
- Try removing and re-adding widget
- Check App Groups / SharedPreferences

---

Need detailed help? See **WIDGET_SETUP.md**
