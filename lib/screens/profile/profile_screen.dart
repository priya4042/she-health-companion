import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/health_tips.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../core/utils/loader_transitions.dart';
import '../../data/providers/profile_provider.dart';

import '../../core/utils/app_lock_service.dart';
import '../../data/providers/theme_provider.dart';
import '../analytics/analytics_screen.dart';
import '../bmi_calculator/bmi_calculator_screen.dart';
import '../emergency_sos/emergency_sos_screen.dart';
import '../export_report/export_report_screen.dart';
import '../gamification/gamification_screen.dart';
import '../affirmations/affirmations_screen.dart';
import '../ai_insights/ai_insights_screen.dart';
import '../ask_doctor/ask_doctor_screen.dart';
import '../bollywood_affirmations/bollywood_affirmations_screen.dart';
import '../breathing/breathing_screen.dart';
import '../buddy_sync/buddy_sync_screen.dart';
import '../cravings/cravings_screen.dart';
import '../daily_reward/daily_reward_screen.dart';
import '../dosha_quiz/dosha_quiz_screen.dart';
import '../festivals/festivals_screen.dart';
import '../habit_tracker/habit_tracker_screen.dart';
import '../home_remedies/home_remedies_screen.dart';
import '../horoscope/horoscope_screen.dart';
import '../mascot/mascot_screen.dart';
import '../memory_lane/memory_lane_screen.dart';
import '../mom_mode/mom_mode_screen.dart';
import '../period_cost/period_cost_screen.dart';
import '../recipes/recipes_screen.dart';
import '../scratch_card/scratch_card_screen.dart';
import '../sleep_tracker/sleep_tracker_screen.dart';
import '../spin_wheel/spin_wheel_screen.dart';
import '../symptom_checker/symptom_checker_screen.dart';
import '../themes/themes_screen.dart';
import '../time_capsule/time_capsule_screen.dart';
import '../virtual_plant/virtual_plant_screen.dart';
import '../water_tracker/water_tracker_screen.dart';
import '../weekly_report/weekly_report_screen.dart';
import '../weight_tracker/weight_tracker_screen.dart';
import '../workout/workout_screen.dart';
import '../year_review/year_review_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final theme = context.watch<ThemeProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Profile header
            _buildProfileHeader(context, profile),
            const SizedBox(height: 24),

            // Quick links
            _buildMenuCard(
              context,
              icon: Icons.water_drop_rounded,
              title: 'Water Tracker',
              subtitle: 'Track daily water intake',
              color: AppColors.waterColor,
              onTap: () => Navigator.push(
                context,
                LoaderPageRoute(page: const WaterTrackerScreen()),
              ),
            ),
            _buildMenuCard(
              context,
              icon: Icons.monitor_weight_rounded,
              title: 'BMI Calculator',
              subtitle: 'Check your body mass index',
              color: AppColors.bmiColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(
                  context,
                  LoaderPageRoute(page: const BmiCalculatorScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.analytics_rounded,
              title: 'Health Analytics',
              subtitle: 'View your health insights',
              color: AppColors.analyticsColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(
                  context,
                  LoaderPageRoute(page: const AnalyticsScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.bedtime_rounded,
              title: 'Sleep Tracker',
              subtitle: 'Track your sleep patterns',
              color: const Color(0xFF5C6BC0),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const SleepTrackerScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.emoji_events_rounded,
              title: 'Challenges & Rewards',
              subtitle: 'Complete daily challenges',
              color: AppColors.moodColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const GamificationScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.sos_rounded,
              title: 'Emergency SOS',
              subtitle: 'Quick access to emergency help',
              color: AppColors.error,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const EmergencySosScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.picture_as_pdf_rounded,
              title: 'Export Health Report',
              subtitle: 'Generate PDF for your doctor',
              color: AppColors.analyticsColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const ExportReportScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.monitor_weight_rounded,
              title: 'Weight & Body Tracker',
              subtitle: 'Track weight, waist, hip',
              color: AppColors.bmiColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const WeightTrackerScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.checklist_rounded,
              title: 'Habit Tracker',
              subtitle: 'Build daily healthy habits',
              color: AppColors.periodColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const HabitTrackerScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.local_florist_rounded,
              title: 'Home Remedies',
              subtitle: 'Gharelu nuskhe & natural cures',
              color: AppColors.healthColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const HomeRemediesScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.assessment_rounded,
              title: 'Weekly Report Card',
              subtitle: 'Your health score & grade',
              color: AppColors.waterColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const WeeklyReportScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.palette_rounded,
              title: 'Themes',
              subtitle: 'Unlock beautiful color themes',
              color: AppColors.moodColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const ThemesScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.fitness_center_rounded,
              title: 'Cycle Workouts',
              subtitle: 'Workouts synced to your cycle',
              color: AppColors.success,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const WorkoutScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.health_and_safety_rounded,
              title: 'Symptom Checker',
              subtitle: 'AI-powered symptom analysis',
              color: const Color(0xFF7E57C2),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const SymptomCheckerScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.attach_money_rounded,
              title: 'Period Cost Calculator',
              subtitle: 'How much do periods cost you?',
              color: AppColors.periodColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const PeriodCostScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.fastfood_rounded,
              title: 'Cravings Logger',
              subtitle: 'Track your food cravings',
              color: const Color(0xFFFF8A65),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const CravingsScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.eco_rounded,
              title: 'Virtual Plant',
              subtitle: 'Grow with your healthy habits',
              color: AppColors.success,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const VirtualPlantScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.auto_awesome_rounded,
              title: 'Daily Affirmations',
              subtitle: 'Positive thoughts every day',
              color: const Color(0xFFC850C0),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const AffirmationsScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.spa_rounded,
              title: 'Ayurveda Dosha Quiz',
              subtitle: 'Discover your body type',
              color: const Color(0xFF26A69A),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const DoshaQuizScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.restaurant_menu_rounded,
              title: 'Healthy Recipes',
              subtitle: 'Indian recipes for wellness',
              color: AppColors.healthColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const RecipesScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.psychology_rounded,
              title: 'Health Horoscope',
              subtitle: 'Daily reading for your sign',
              color: const Color(0xFF673AB7),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const HoroscopeScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.air_rounded,
              title: 'Breathing Exercises',
              subtitle: 'Calm your mind & body',
              color: AppColors.waterColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const BreathingScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.celebration_rounded,
              title: 'Festival Tracker',
              subtitle: 'Plan around Indian festivals',
              color: const Color(0xFFFF6B35),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const FestivalsScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.medical_services_rounded,
              title: 'Doctor Visit Prep',
              subtitle: 'Generate notes for your doctor',
              color: const Color(0xFF26A69A),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const AskDoctorScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.people_rounded,
              title: 'Period Buddy Sync',
              subtitle: 'Share your cycle with bestie',
              color: AppColors.periodColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const BuddySyncScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.family_restroom_rounded,
              title: 'Mom & Me Mode',
              subtitle: 'Educational content for girls',
              color: AppColors.moodColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const MomModeScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.card_giftcard_rounded,
              title: 'Daily Reward',
              subtitle: 'Claim points & unlock stickers',
              color: const Color(0xFFFFD700),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const DailyRewardScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.celebration_rounded,
              title: 'Year in Review',
              subtitle: 'Spotify Wrapped for your health',
              color: const Color(0xFFC850C0),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const YearReviewScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.history_rounded,
              title: 'Memory Lane',
              subtitle: 'On this day in past years',
              color: const Color(0xFFAB47BC),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const MemoryLaneScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.casino_rounded,
              title: 'Spin the Wheel',
              subtitle: 'Daily lucky spin for prizes',
              color: const Color(0xFFFF6B35),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const SpinWheelScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.pets_rounded,
              title: 'Bloomy (Mascot)',
              subtitle: 'Your animated health buddy',
              color: AppColors.periodColor,
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const MascotScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.style_rounded,
              title: 'Scratch Card',
              subtitle: 'Daily mystery prizes',
              color: const Color(0xFFFFD700),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const ScratchCardScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.psychology_alt_rounded,
              title: 'AI Insights',
              subtitle: 'Smart patterns from your data',
              color: const Color(0xFF673AB7),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const AiInsightsScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.movie_filter_rounded,
              title: 'Bollywood Affirmations',
              subtitle: 'Affirmations with desi swag',
              color: const Color(0xFFE91E63),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const BollywoodAffirmationsScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.mail_lock_rounded,
              title: 'Time Capsule',
              subtitle: 'Letters to your future self',
              color: const Color(0xFF8E24AA),
              onTap: () {
                HapticUtils.lightTap();
                Navigator.push(context, LoaderPageRoute(page: const TimeCapsuleScreen()));
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.tips_and_updates_rounded,
              title: 'Health Tips',
              subtitle: 'Browse tips by category',
              color: AppColors.healthColor,
              onTap: () => _showHealthTips(context),
            ),
            _buildMenuCard(
              context,
              icon: Icons.lock_rounded,
              title: 'App Lock',
              subtitle: 'Protect with biometrics',
              color: const Color(0xFF8E24AA),
              onTap: () => _toggleAppLock(context),
            ),
            _buildMenuCard(
              context,
              icon: theme.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              title: theme.isDarkMode ? 'Light Mode' : 'Dark Mode',
              subtitle: 'Switch app appearance',
              color: AppColors.secondary,
              onTap: theme.toggleTheme,
            ),
            _buildMenuCard(
              context,
              icon: Icons.settings_rounded,
              title: 'Settings',
              subtitle: 'App preferences',
              color: Colors.grey,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            _buildMenuCard(
              context,
              icon: Icons.info_outline_rounded,
              title: 'About',
              subtitle: 'Version 1.0.0',
              color: AppColors.info,
              onTap: () => _showAbout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileProvider profile) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              profile.name.isNotEmpty
                  ? profile.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          profile.name.isNotEmpty ? profile.name : 'Set your name',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (profile.age > 0)
          Text(
            'Age: ${profile.age}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _showEditProfile(context, profile),
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit Profile'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, ProfileProvider profile) {
    final nameController = TextEditingController(text: profile.name);
    final ageController = TextEditingController(
        text: profile.age > 0 ? profile.age.toString() : '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24, 24, 24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final age = int.tryParse(v);
                    if (age == null || age < 10 || age > 100) {
                      return 'Enter valid age (10-100)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      profile.updateProfile(
                        name: nameController.text.trim(),
                        age: int.parse(ageController.text.trim()),
                      );
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHealthTips(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (ctx, scrollController) {
            return DefaultTabController(
              length: HealthTips.categories.length,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Health Tips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TabBar(
                    isScrollable: true,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primary,
                    tabs: HealthTips.categories
                        .map((c) => Tab(text: c))
                        .toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: HealthTips.categories.map((category) {
                        final tips = HealthTips.getTips(category);
                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: tips.length,
                          itemBuilder: (_, i) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.healthColor
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.healthColor
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: const TextStyle(
                                          color: AppColors.healthColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      tips[i],
                                      style: const TextStyle(
                                        height: 1.4,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleAppLock(BuildContext context) async {
    final lockService = AppLockService.instance;
    final available = await lockService.isBiometricAvailable();

    if (!available) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available on this device')),
        );
      }
      return;
    }

    final currentlyEnabled = lockService.isEnabled;
    if (currentlyEnabled) {
      await lockService.setEnabled(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('App Lock disabled')),
        );
      }
    } else {
      final authenticated = await lockService.authenticate();
      if (authenticated) {
        await lockService.setEnabled(true);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App Lock enabled! Your data is now protected.')),
          );
        }
      }
    }
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Daily Life Helper',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.favorite, color: Colors.white, size: 24),
      ),
      children: [
        const Text(
          'Your complete health companion.\n\n'
          'Track periods, medicines, water intake, and get daily health tips '
          'tailored for Indian women.',
        ),
      ],
    );
  }
}
