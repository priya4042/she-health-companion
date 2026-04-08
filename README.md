# Daily Life Helper – Health, Period & Medicine Reminder

A complete Flutter application for health tracking, period tracking, medicine reminders, and water intake monitoring. Optimized for Indian users.

---

## Features

- **Period Tracker**: Calendar-based period tracking with cycle prediction, symptom logging, and cycle analytics
- **Medicine Reminder**: Add medicines with multiple daily times, local notifications, mark as taken/missed
- **Water Tracker**: Daily water intake tracking with weekly charts, customizable goals, and smart reminders
- **Health Tips**: Curated daily tips for PCOD, Hair Care, Skin Care, and General Health
- **Dark Mode**: Full dark/light theme support
- **Offline-first**: All data stored locally using Hive database

---

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # App-wide constants
│   │   └── health_tips.dart           # Static health tips data
│   ├── theme/
│   │   ├── app_colors.dart            # Color palette
│   │   └── app_theme.dart             # Light & dark themes
│   └── utils/
│       ├── date_utils.dart            # Date formatting helpers
│       └── notification_service.dart  # Local notifications manager
├── data/
│   ├── models/
│   │   ├── period_model.dart          # Period & symptom models
│   │   ├── medicine_model.dart        # Medicine & dose models
│   │   └── water_model.dart           # Water intake model
│   └── providers/
│       ├── theme_provider.dart        # Theme state management
│       ├── profile_provider.dart      # User profile management
│       ├── period_provider.dart       # Period tracking logic
│       ├── medicine_provider.dart     # Medicine reminder logic
│       └── water_provider.dart        # Water tracking logic
├── screens/
│   ├── splash/splash_screen.dart
│   ├── onboarding/onboarding_screen.dart
│   ├── home/
│   │   ├── main_screen.dart           # Bottom nav shell
│   │   └── home_screen.dart           # Dashboard
│   ├── period_tracker/period_tracker_screen.dart
│   ├── medicine_reminder/medicine_reminder_screen.dart
│   ├── water_tracker/water_tracker_screen.dart
│   ├── profile/profile_screen.dart
│   └── settings/settings_screen.dart
└── widgets/
    └── custom_card.dart               # Reusable card widget
```

---

## Setup Instructions

### Prerequisites

1. **Flutter SDK** (>=3.2.0): https://docs.flutter.dev/get-started/install
2. **Android Studio** with Android SDK
3. **VS Code** or Android Studio as IDE

### Step-by-step Setup

```bash
# 1. Navigate to project directory
cd daily_life_helper

# 2. Get dependencies
flutter pub get

# 3. Generate Hive adapters (if modifying models)
# Note: Pre-generated .g.dart files are included
# To regenerate:
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run on device/emulator
flutter run

# 5. Run on specific device
flutter devices           # List available devices
flutter run -d <device>   # Run on specific device
```

### Android-Specific Setup

#### Notifications (Required)

Add to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

Add to `android/app/src/main/AndroidManifest.xml` inside `<application>`:

```xml
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

#### Minimum SDK Version

In `android/app/build.gradle`, ensure:
```groovy
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

---

## Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK (requires signing)
flutter build apk --release

# App Bundle for Play Store (recommended)
flutter build appbundle --release
```

### Signing for Release

1. Generate a keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>/upload-keystore.jks
```

3. Update `android/app/build.gradle` to reference the key.

---

## Future Integration Suggestions

### Google AdMob

1. Add dependency:
```yaml
google_mobile_ads: ^5.1.0
```

2. Add to `AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
```

3. Best ad placements:
   - **Banner ad**: Bottom of Home dashboard
   - **Interstitial ad**: After completing onboarding, between screen transitions
   - **Native ad**: Within health tips list
   - **Rewarded ad**: Unlock premium health tips

### Firebase Integration

1. Add dependencies:
```yaml
firebase_core: ^3.8.0
firebase_analytics: ^11.3.6
firebase_auth: ^5.3.4
cloud_firestore: ^5.5.4
```

2. Recommended Firebase features:
   - **Analytics**: Track user engagement with each feature
   - **Auth**: Allow cloud backup with Google Sign-In
   - **Firestore**: Sync data across devices
   - **Cloud Messaging**: Push notifications for health campaigns
   - **Remote Config**: Update health tips without app update
   - **Crashlytics**: Monitor production crashes

---

## Play Store Submission Checklist

- [ ] App icon (512x512 PNG) and feature graphic (1024x500)
- [ ] Screenshots for phone and tablet (min 2, max 8)
- [ ] Privacy policy URL (required for health apps)
- [ ] App signing with upload key
- [ ] Content rating questionnaire completed
- [ ] Target API level 34+
- [ ] Data safety form (local-only data storage)
- [ ] App description with Hindi + English keywords for Indian market
- [ ] Category: Health & Fitness

---

## Tech Stack

| Component          | Technology                          |
|-------------------|-------------------------------------|
| Framework         | Flutter 3.2+                        |
| State Management  | Provider                            |
| Local Database    | Hive                                |
| Notifications     | flutter_local_notifications         |
| Charts            | fl_chart                            |
| Calendar          | table_calendar                      |
| Fonts             | Google Fonts (Poppins)              |

---

## License

This project is proprietary. All rights reserved.
