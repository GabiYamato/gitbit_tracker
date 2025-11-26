# ✅ iOS Widget Setup Checklist

Follow these steps in order to get iOS widgets working.

## Before You Start
- [ ] Xcode 14.0 or later installed
- [ ] iOS 14.0+ device or simulator
- [ ] Project builds successfully: `flutter run`

## Step 1: Open Xcode
```bash
cd ios
open Runner.xcworkspace
```
Wait for Xcode to fully load and index the project.

## Step 2: Add Widget Extension
- [ ] Click project name "Runner" in left sidebar
- [ ] At bottom of targets list, click the **+** button
- [ ] Scroll and select **"Widget Extension"**
- [ ] Product Name: `HabitWidget`
- [ ] **Uncheck** "Include Configuration Intent"
- [ ] Click **Finish**
- [ ] Click **Activate** when asked about scheme

## Step 3: Delete Auto-Generated Files
Xcode created some files we don't need:
- [ ] In `HabitWidget` group, delete `HabitWidget.swift` (Xcode's version)
- [ ] In `HabitWidget` group, delete `Info.plist` (Xcode's version)
- [ ] Move to trash when prompted

## Step 4: Add Our Widget Files
- [ ] Right-click `HabitWidget` folder in Xcode
- [ ] Select "Add Files to Runner..."
- [ ] Navigate to your project's `ios/HabitWidget/` folder
- [ ] Select BOTH files:
  - `HabitWidget.swift`
  - `Info.plist`
- [ ] **UNCHECK** "Copy items if needed"
- [ ] Under "Add to targets", CHECK **HabitWidget** only
- [ ] Click **Add**

## Step 5: Configure App Groups - Runner
- [ ] Select **Runner** target (top of list)
- [ ] Click **"Signing & Capabilities"** tab
- [ ] Click **"+ Capability"** button
- [ ] Type and select **"App Groups"**
- [ ] Click **+** under "App Groups"
- [ ] Enter: `group.com.example.gitbittracker`
- [ ] Click **OK**
- [ ] Verify checkmark appears next to the group

## Step 6: Configure App Groups - HabitWidget
- [ ] Select **HabitWidget** target
- [ ] Click **"Signing & Capabilities"** tab
- [ ] Click **"+ Capability"** button
- [ ] Type and select **"App Groups"**
- [ ] **CHECK** the existing: `group.com.example.gitbittracker`
- [ ] Verify checkmark appears next to the group

## Step 7: Add Entitlements File
- [ ] Select **Runner** target
- [ ] Click **"Build Settings"** tab
- [ ] Search for: `code signing entitlements`
- [ ] Under "Code Signing Entitlements"
- [ ] Set value to: `Runner/Runner.entitlements`

## Step 8: Verify Bundle Identifiers
- [ ] Select **Runner** target → "General" tab
- [ ] Bundle Identifier should be: `com.example.gitbittracker`
- [ ] Select **HabitWidget** target → "General" tab
- [ ] Bundle Identifier should be: `com.example.gitbittracker.HabitWidget`

## Step 9: Build and Run
- [ ] Select a device or simulator (iOS 14+)
- [ ] Press **Cmd+R** or click ▶️ Play button
- [ ] Wait for build to complete
- [ ] App should launch successfully

## Step 10: Add Widget to Home Screen
On your device/simulator:
- [ ] Press Home button (or swipe up)
- [ ] Long press on empty space
- [ ] Tap **+** button (top left)
- [ ] Search or scroll to find "Habit Tracker"
- [ ] Choose a size: Small, Medium, or Large
- [ ] Tap "Add Widget"
- [ ] Done!

## Step 11: Test Widget
- [ ] Open the app
- [ ] Add a habit
- [ ] Go back to home screen
- [ ] Widget should show your habit
- [ ] Tap checkbox in app
- [ ] Widget should update within 15 minutes

## Troubleshooting

### ❌ "No such module 'WidgetKit'"
- [ ] Check deployment target is iOS 14.0+
- [ ] Select Runner target → General → Minimum Deployments → iOS 14.0
- [ ] Select HabitWidget target → General → Minimum Deployments → iOS 14.0
- [ ] Clean build: **Shift+Cmd+K**

### ❌ Widget doesn't show in widget gallery
- [ ] Verify both targets have App Groups configured
- [ ] Check group name is exactly: `group.com.example.gitbittracker`
- [ ] Clean build and reinstall app
- [ ] Restart simulator/device

### ❌ Widget shows but no data
- [ ] Open app and add a habit first
- [ ] Check App Groups are configured in BOTH targets
- [ ] Verify group names match exactly
- [ ] Try removing and re-adding widget

### ❌ Build errors
- [ ] Clean: **Shift+Cmd+K**
- [ ] Close Xcode completely
- [ ] Delete: `ios/Pods`, `ios/Podfile.lock`, `ios/.symlinks`
- [ ] Terminal: `cd ios && pod install`
- [ ] Reopen: `open Runner.xcworkspace`

### ❌ "Provisioning profile doesn't support App Groups"
If testing on a real device:
- [ ] You need a paid Apple Developer account ($99/year)
- [ ] Or continue testing on simulator (free)

## Success! 🎉

If you completed all steps, you should now have:
- ✅ Widget showing in widget gallery
- ✅ Widget displaying your habits
- ✅ Widget updating when you change habits
- ✅ Multiple widget sizes available

---

# ✅ Android Widget Setup Checklist

Good news! Android widgets are already configured and ready to use!

## Step 1: Build the App
```bash
flutter run
```
- [ ] App builds successfully
- [ ] App runs on your device/emulator

## Step 2: Add Widget to Home Screen
On your Android device:
- [ ] Long press on empty space on home screen
- [ ] Tap **"Widgets"**
- [ ] Scroll to find **"Habit Tracker"**
- [ ] Long press the widget
- [ ] Drag to desired position on home screen
- [ ] Release to place
- [ ] Resize if needed

## Step 3: Test Widget
- [ ] Open the app
- [ ] Add a habit
- [ ] Complete it by tapping checkbox
- [ ] Go to home screen
- [ ] Widget should update (may take up to 15 min)

## Troubleshooting

### ❌ Widget not in widget list
- [ ] Uninstall app completely
- [ ] Run: `flutter clean`
- [ ] Run: `flutter run`
- [ ] Check widget list again

### ❌ Widget shows blank
- [ ] Check Android logcat for errors
- [ ] Add a habit in the app first
- [ ] Remove and re-add widget

### ❌ Widget not updating
- [ ] Wait up to 15 minutes (Android limitation)
- [ ] Or remove and re-add widget to force update
- [ ] Check that `WidgetService.updateWidgets()` is being called

## Success! 🎉

Android widgets are working if:
- ✅ Widget appears in widget picker
- ✅ Widget shows on home screen
- ✅ Widget displays your habits
- ✅ Widget updates when habits change

---

## Next Steps

1. **Use the app daily** to track your habits
2. **Experiment with different widget sizes** (iOS)
3. **Customize colors** in `lib/themes/app_theme.dart`
4. **Add more habits** to see widget populate

## Need More Help?

- See **WIDGET_QUICK_START.md** for quick reference
- See **WIDGET_SETUP.md** for detailed information
- See **README.md** for general app documentation

Happy habit tracking! 🎯
