import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_lock_service.dart';
import 'core/utils/notification_service.dart';
import 'data/models/challenge_model.dart';
import 'data/models/challenge_model.dart';
import 'data/models/habit_model.dart';
import 'data/models/medicine_model.dart';
import 'data/models/mood_model.dart';
import 'data/models/period_model.dart';
import 'data/models/sleep_model.dart';
import 'data/models/streak_model.dart';
import 'data/models/water_model.dart';
import 'data/models/weight_model.dart';
import 'data/providers/gamification_provider.dart';
import 'data/providers/habit_provider.dart';
import 'data/providers/medicine_provider.dart';
import 'data/providers/mood_provider.dart';
import 'data/providers/period_provider.dart';
import 'data/providers/profile_provider.dart';
import 'data/providers/sleep_provider.dart';
import 'data/providers/streak_provider.dart';
import 'data/providers/theme_provider.dart';
import 'data/providers/water_provider.dart';
import 'data/providers/weight_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(PeriodRecordAdapter());
  Hive.registerAdapter(SymptomEntryAdapter());
  Hive.registerAdapter(MedicineModelAdapter());
  Hive.registerAdapter(MedicineDoseAdapter());
  Hive.registerAdapter(WaterIntakeAdapter());
  Hive.registerAdapter(MoodEntryAdapter());
  Hive.registerAdapter(StreakModelAdapter());
  Hive.registerAdapter(SleepRecordAdapter());
  Hive.registerAdapter(DailyChallengeAdapter());
  Hive.registerAdapter(UserAchievementAdapter());
  Hive.registerAdapter(WeightRecordAdapter());
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(HabitCompletionAdapter());

  // Open Hive boxes
  await Hive.openBox<PeriodRecord>(AppConstants.periodBox);
  await Hive.openBox<SymptomEntry>(AppConstants.symptomsBox);
  await Hive.openBox<MedicineModel>(AppConstants.medicineBox);
  await Hive.openBox<MedicineDose>(AppConstants.medicineDoseBox);
  await Hive.openBox<WaterIntake>(AppConstants.waterBox);
  await Hive.openBox<MoodEntry>(AppConstants.moodBox);
  await Hive.openBox<StreakModel>(AppConstants.streakBox);
  await Hive.openBox<SleepRecord>(AppConstants.sleepBox);
  await Hive.openBox<DailyChallenge>(AppConstants.challengeBox);
  await Hive.openBox<UserAchievement>(AppConstants.achievementBox);
  await Hive.openBox<WeightRecord>(AppConstants.weightBox);
  await Hive.openBox<HabitModel>(AppConstants.habitBox);
  await Hive.openBox<HabitCompletion>(AppConstants.habitCompletionBox);
  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox(AppConstants.profileBox);

  // Initialize services
  await NotificationService.instance.init();
  await AppLockService.instance.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const DailyLifeHelperApp());
}

class DailyLifeHelperApp extends StatelessWidget {
  const DailyLifeHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PeriodProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => WaterProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(create: (_) => StreakProvider()),
        ChangeNotifierProvider(create: (_) => SleepProvider()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
        ChangeNotifierProvider(create: (_) => WeightProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Daily Life Helper',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            // Localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
