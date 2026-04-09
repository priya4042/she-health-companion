import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/medicine_provider.dart';
import '../period_tracker/period_tracker_screen.dart';
import '../medicine_reminder/medicine_reminder_screen.dart';
import '../mood_journal/mood_journal_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    PeriodTrackerScreen(),
    MoodJournalScreen(),
    MedicineReminderScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineProvider>().ensureTodayDoses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 65,
        backgroundColor: Colors.transparent,
        color: isDark ? AppColors.cardDark : Colors.white,
        buttonBackgroundColor: AppColors.primary,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOutCubic,
        items: [
          Icon(Icons.home_rounded,
              size: 26,
              color: _currentIndex == 0 ? Colors.white : Colors.grey),
          Icon(Icons.favorite_rounded,
              size: 26,
              color: _currentIndex == 1 ? Colors.white : Colors.grey),
          Icon(Icons.emoji_emotions_rounded,
              size: 26,
              color: _currentIndex == 2 ? Colors.white : Colors.grey),
          Icon(Icons.medication_rounded,
              size: 26,
              color: _currentIndex == 3 ? Colors.white : Colors.grey),
          Icon(Icons.person_rounded,
              size: 26,
              color: _currentIndex == 4 ? Colors.white : Colors.grey),
        ],
        onTap: (index) {
          HapticUtils.lightTap();
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
