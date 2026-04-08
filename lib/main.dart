import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/notification_service.dart';
import 'data/models/medicine_model.dart';
import 'data/models/period_model.dart';
import 'data/models/water_model.dart';
import 'data/providers/medicine_provider.dart';
import 'data/providers/period_provider.dart';
import 'data/providers/profile_provider.dart';
import 'data/providers/theme_provider.dart';
import 'data/providers/water_provider.dart';
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

  // Open Hive boxes
  await Hive.openBox<PeriodRecord>(AppConstants.periodBox);
  await Hive.openBox<SymptomEntry>(AppConstants.symptomsBox);
  await Hive.openBox<MedicineModel>(AppConstants.medicineBox);
  await Hive.openBox<MedicineDose>(AppConstants.medicineDoseBox);
  await Hive.openBox<WaterIntake>(AppConstants.waterBox);
  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox(AppConstants.profileBox);

  // Initialize notifications
  await NotificationService.instance.init();

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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Daily Life Helper',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
