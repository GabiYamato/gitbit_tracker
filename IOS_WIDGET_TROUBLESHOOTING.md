# 🔧 iOS Widget Troubleshooting Guide

## Issue: "No results found for the widget on iOS"

This typically means the widget extension isn't properly configured in Xcode. Follow these steps:

## Step 1: Verify Xcode Configuration

### Open Xcode
```bash
cd ios
open Runner.xcworkspace
```

### Check Widget Extension Target Exists
1. In Xcode's left sidebar, verify you have a **"HabitWidget"** target
2. If not, you need to add the Widget Extension (see WIDGET_CHECKLIST.md)

## Step 2: Add Entitlements File to Widget Extension

This is the **most common issue** - the widget extension needs its own entitlements file.

1. In Xcode, select **HabitWidget** target
2. Click **"Signing & Capabilities"** tab
3. Under **"Signing"** section, find **"Code Signing Entitlements"**
4. Click the dropdown and select **"Other..."**
5. Navigate to and select: `HabitWidget/HabitWidget.entitlements`
6. The path should now show: `HabitWidget/HabitWidget.entitlements`

**OR** use Build Settings:
1. Select **HabitWidget** target
2. Click **"Build Settings"** tab
3. Search for: `code signing entitlements`
4. Double-click the value under "Code Signing Entitlements"
5. Enter: `HabitWidget/HabitWidget.entitlements`

## Step 3: Configure App Groups (Both Targets)

### For Runner Target:
1. Select **Runner** target
2. Click **"Signing & Capabilities"** tab
3. Verify **"App Groups"** capability exists
4. If not, click **"+ Capability"** → **"App Groups"**
5. Check the box next to: `group.com.example.gitbittracker`
6. **Important:** The checkmark must be filled/selected

### For HabitWidget Target:
1. Select **HabitWidget** target
2. Click **"Signing & Capabilities"** tab
3. Verify **"App Groups"** capability exists
4. If not, click **"+ Capability"** → **"App Groups"**
5. **Check** the box next to: `group.com.example.gitbittracker`
6. The same group must appear in BOTH targets with checkmarks

## Step 4: Verify Bundle Identifiers

### Runner Target:
1. Select **Runner** target → **"General"** tab
2. Bundle Identifier should be: `com.example.gitbittracker`

### HabitWidget Target:
1. Select **HabitWidget** target → **"General"** tab
2. Bundle Identifier should be: `com.example.gitbittracker.HabitWidget`
3. **Must end with `.HabitWidget`** and match Runner's bundle ID

## Step 5: Verify Files Are Added to Target

1. In Xcode's left sidebar, find **HabitWidget** folder
2. Click on **`HabitWidget.swift`**
3. In right sidebar, under **"Target Membership"**
4. Verify **only HabitWidget** is checked (NOT Runner)

Do the same for `Info.plist` and `HabitWidget.entitlements`

## Step 6: Clean Build

1. In Xcode: **Product** → **Clean Build Folder** (⇧⌘K)
2. Close Xcode completely
3. Delete derived data:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*
```
4. Reopen Xcode:
```bash
open ios/Runner.xcworkspace
```

## Step 7: Rebuild and Install

1. Select a device or simulator (iOS 14.0+)
2. Select **Runner** scheme (top toolbar)
3. Press **⌘R** to build and run
4. Wait for app to install and launch

## Step 8: Add Widget to Home Screen

1. Press Home button to go to home screen
2. **Long press** on empty area
3. Tap **"+"** button (top left corner)
4. In search bar, type: **"Habit"**
5. Look for **"Habit Tracker"** widget
6. If you see it, tap to add!

## Still Not Working? Try These:

### Option A: Restart Device/Simulator
```bash
# If using simulator
xcrun simctl shutdown all
xcrun simctl boot "iPhone 15 Pro"  # Or your simulator name
```

### Option B: Check Deployment Target
1. Select **Runner** target → **"General"**
2. Under **"Deployment Info"**, set **"Minimum Deployments"** to **iOS 14.0**
3. Select **HabitWidget** target → **"General"**
4. Under **"Deployment Info"**, set **"Minimum Deployments"** to **iOS 14.0**

### Option C: Verify Widget Files
Run this from your project root:
```bash
ls -la ios/HabitWidget/
```

You should see:
- `HabitWidget.swift` ✅
- `Info.plist` ✅
- `HabitWidget.entitlements` ✅

### Option D: Check Console for Errors
1. In Xcode: **Window** → **Devices and Simulators**
2. Select your device/simulator
3. Click **"Open Console"** button
4. Run the app and look for errors mentioning "Widget" or "HabitWidget"

## Debugging: Test Widget Data

Add a habit in the app, then check if data is being saved:

1. Run this code in `main.dart` temporarily:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final habitService = HabitService();
  await habitService.init();

  final widgetService = WidgetService(habitService);
  await widgetService.init();
  
  // Test data saving
  print('🔍 Testing widget data...');
  await widgetService.updateWidgets();
  
  widgetService.registerCallbacks();
  runApp(MyApp(habitService: habitService, widgetService: widgetService));
}
```

2. Watch the debug console for prints like:
```
📱 Updating widgets with 2 habits
📊 Saved habit_count: 2
💾 Saved habit 0: Morning Run (streak: 5)
💾 Saved habit 1: Reading (streak: 3)
✅ Widget update complete
```

If you see these logs, data is being saved correctly!

## Common Mistakes Checklist

- [ ] Both targets have App Groups capability
- [ ] Both targets use the SAME group name: `group.com.example.gitbittracker`
- [ ] HabitWidget has entitlements file configured
- [ ] HabitWidget bundle ID ends with `.HabitWidget`
- [ ] Widget files are in HabitWidget target (not Runner)
- [ ] Deployment target is iOS 14.0 or higher
- [ ] Clean build performed
- [ ] App was reinstalled after changes

## If Widget Shows "No habits"

This is actually good - it means the widget is working!

1. Open the app
2. Add a habit using the **"+"** button
3. Complete it by tapping the checkbox
4. Go back to home screen
5. Wait 15 minutes OR remove and re-add widget to force update

## Need More Help?

Check these files in your project:
- `WIDGET_CHECKLIST.md` - Step-by-step setup
- `WIDGET_QUICK_START.md` - Quick reference
- `WIDGET_SETUP.md` - Technical details

## Quick Test Command

Run the app and add a habit, then check the console:
```bash
flutter run
```

Look for the widget update logs. If you see them, the Flutter side is working correctly, and it's just an Xcode configuration issue.
