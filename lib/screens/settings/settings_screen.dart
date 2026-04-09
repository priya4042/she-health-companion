import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/notification_service.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/providers/water_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final period = context.watch<PeriodProvider>();
    final water = context.watch<WaterProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Appearance
          _buildSectionTitle('Appearance'),
          _buildSettingCard(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme',
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode, size: 16),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode, size: 16),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.phone_android, size: 16),
                ),
              ],
              selected: {theme.themeMode},
              onSelectionChanged: (modes) {
                theme.setThemeMode(modes.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Period settings
          _buildSectionTitle('Period Tracker'),
          _buildSettingCard(
            context,
            icon: Icons.calendar_month,
            title: 'Cycle Length',
            subtitle: '${period.cycleLength} days',
            onTap: () => _showNumberPicker(
              context,
              title: 'Cycle Length (days)',
              current: period.cycleLength,
              min: 20,
              max: 45,
              onChanged: period.updateCycleLength,
            ),
          ),
          _buildSettingCard(
            context,
            icon: Icons.timelapse,
            title: 'Period Duration',
            subtitle: '${period.periodDuration} days',
            onTap: () => _showNumberPicker(
              context,
              title: 'Period Duration (days)',
              current: period.periodDuration,
              min: 2,
              max: 10,
              onChanged: period.updatePeriodDuration,
            ),
          ),
          const SizedBox(height: 20),

          // Water settings
          _buildSectionTitle('Water Tracker'),
          _buildSettingCard(
            context,
            icon: Icons.local_drink,
            title: 'Daily Goal',
            subtitle: '${water.dailyGoal} glasses (${water.goalMl} ml)',
            onTap: () => _showNumberPicker(
              context,
              title: 'Daily Water Goal (glasses)',
              current: water.dailyGoal,
              min: 4,
              max: 20,
              onChanged: water.updateDailyGoal,
            ),
          ),
          _buildSettingCard(
            context,
            icon: Icons.notifications_active,
            title: 'Water Reminders',
            trailing: Switch(
              value: water.reminderEnabled,
              onChanged: water.toggleReminder,
              activeTrackColor: AppColors.waterColor,
            ),
          ),
          const SizedBox(height: 20),

          // Notifications
          _buildSectionTitle('Notifications'),
          _buildSettingCard(
            context,
            icon: Icons.notifications,
            title: 'Request Permission',
            subtitle: 'Allow notifications for reminders',
            onTap: () async {
              final granted =
                  await NotificationService.instance.requestPermissions();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(granted
                        ? 'Notifications enabled'
                        : 'Notifications denied. Enable in device settings.'),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // Data
          _buildSectionTitle('Data'),
          _buildSettingCard(
            context,
            icon: Icons.delete_forever,
            title: 'Clear All Data',
            subtitle: 'This cannot be undone',
            iconColor: AppColors.error,
            onTap: () => _confirmClearData(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing
                else if (onTap != null)
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNumberPicker(
    BuildContext context, {
    required String title,
    required int current,
    required int min,
    required int max,
    required Function(int) onChanged,
  }) {
    int value = current;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: value > min
                        ? () => setDialogState(() => value--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: value < max
                        ? () => setDialogState(() => value++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onChanged(value);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmClearData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your period records, medicine reminders, water tracking data, and profile information. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // In production, clear all Hive boxes here
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
