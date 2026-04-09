import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/health_tips.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../core/utils/page_transitions.dart';
import '../../data/providers/profile_provider.dart';

import '../../core/utils/app_lock_service.dart';
import '../../data/providers/theme_provider.dart';
import '../analytics/analytics_screen.dart';
import '../bmi_calculator/bmi_calculator_screen.dart';
import '../emergency_sos/emergency_sos_screen.dart';
import '../export_report/export_report_screen.dart';
import '../gamification/gamification_screen.dart';
import '../habit_tracker/habit_tracker_screen.dart';
import '../home_remedies/home_remedies_screen.dart';
import '../sleep_tracker/sleep_tracker_screen.dart';
import '../themes/themes_screen.dart';
import '../water_tracker/water_tracker_screen.dart';
import '../weekly_report/weekly_report_screen.dart';
import '../weight_tracker/weight_tracker_screen.dart';
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
                SlidePageRoute(page: const WaterTrackerScreen()),
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
                  SlidePageRoute(page: const BmiCalculatorScreen()),
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
                  SlidePageRoute(page: const AnalyticsScreen()),
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
                Navigator.push(context, SlidePageRoute(page: const SleepTrackerScreen()));
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
                Navigator.push(context, SlidePageRoute(page: const GamificationScreen()));
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
                Navigator.push(context, SlidePageRoute(page: const EmergencySosScreen()));
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
                Navigator.push(context, SlidePageRoute(page: const ExportReportScreen()));
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
                Navigator.push(context, SlidePageRoute(page: const WeightTrackerScreen()));
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
                Navigator.push(context, SlidePageRoute(page: const HabitTrackerScreen()));
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
                Navigator.push(context, SlidePageRoute(page: const HomeRemediesScreen()));
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
                Navigator.push(context, SlidePageRoute(page: const WeeklyReportScreen()));
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
                Navigator.push(context, SlidePageRoute(page: const ThemesScreen()));
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
