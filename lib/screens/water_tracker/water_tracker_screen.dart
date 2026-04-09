import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/streak_provider.dart';
import '../../data/providers/water_provider.dart';
import '../../widgets/glass_card.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();
    final streak = context.watch<StreakProvider>();
    final waterStreak = streak.getStreak('water');

    return Scaffold(
      appBar: AppBar(title: const Text('Water Tracker')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Streak badge
                if (waterStreak > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.streakColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(
                          '$waterStreak day streak!',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.streakColor,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 16),

                // Progress circle
                _buildProgressCircle(context, water)
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 30),

                // Add / Remove buttons
                _buildActionButtons(context, water, streak),
                const SizedBox(height: 30),

                // Weekly chart
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: _buildWeeklyChartContent(context, water),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                const SizedBox(height: 24),

                // Settings
                GlassCard(
                  child: _buildSettingsContent(context, water),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                AppColors.waterColor,
                AppColors.success,
                AppColors.primary,
                Colors.yellow,
              ],
              numberOfParticles: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(BuildContext context, WaterProvider water) {
    return CircularPercentIndicator(
      radius: 120,
      lineWidth: 14,
      percent: water.todayProgress,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.water_drop_rounded,
            color: AppColors.waterColor,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            '${water.todayGlasses}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.waterColor,
            ),
          ),
          Text(
            'of ${water.dailyGoal} glasses',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          Text(
            '${water.todayMl} ml',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
      progressColor: water.goalReached ? AppColors.success : AppColors.waterColor,
      backgroundColor: AppColors.waterColor.withValues(alpha: 0.15),
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 800,
    );
  }

  Widget _buildActionButtons(BuildContext context, WaterProvider water, StreakProvider streak) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Remove glass
        Container(
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: water.todayGlasses > 0 ? water.removeLastIntake : null,
            icon: const Icon(Icons.remove),
            color: AppColors.error,
            iconSize: 28,
          ),
        ),
        const SizedBox(width: 24),

        // Add glass button
        GestureDetector(
          onTap: () async {
            final wasGoalReached = water.goalReached;
            await water.addWater();
            if (!wasGoalReached && water.goalReached) {
              _confettiController.play();
              HapticUtils.success();
              await streak.recordCompletion('water');
            } else {
              HapticUtils.lightTap();
            }
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.waterColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white, size: 28),
                Text(
                  '1 Glass',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Add 2 glasses
        Container(
          decoration: BoxDecoration(
            color: AppColors.waterColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () => water.addWater(glasses: 2),
            icon: const Text(
              '+2',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            color: AppColors.waterColor,
            iconSize: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChartContent(BuildContext context, WaterProvider water) {
    final weeklyData = water.weeklyData;
    final maxY = (water.dailyGoal + 2).toDouble();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final keys = weeklyData.keys.toList();
                        if (value.toInt() < keys.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              keys[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: weeklyData.entries.toList().asMap().entries.map((e) {
                  final glasses = e.value.value.toDouble();
                  final isGoalMet = glasses >= water.dailyGoal;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: glasses,
                        color: isGoalMet
                            ? AppColors.success
                            : AppColors.waterColor,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
    );
  }

  Widget _buildSettingsContent(BuildContext context, WaterProvider water) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
          const SizedBox(height: 12),

          // Daily goal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily Goal'),
              Row(
                children: [
                  IconButton(
                    onPressed: water.dailyGoal > 4
                        ? () => water.updateDailyGoal(water.dailyGoal - 1)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    iconSize: 20,
                  ),
                  Text(
                    '${water.dailyGoal} glasses',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: water.dailyGoal < 20
                        ? () => water.updateDailyGoal(water.dailyGoal + 1)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),

          // Reminder toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Water Reminders'),
              Switch(
                value: water.reminderEnabled,
                onChanged: water.toggleReminder,
                activeTrackColor: AppColors.waterColor,
              ),
            ],
          ),

          // Reminder interval
          if (water.reminderEnabled)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Reminder Interval'),
                Row(
                  children: [
                    IconButton(
                      onPressed: water.reminderInterval > 1
                          ? () => water.updateReminderInterval(
                              water.reminderInterval - 1)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      iconSize: 20,
                    ),
                    Text(
                      '${water.reminderInterval}h',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      onPressed: water.reminderInterval < 6
                          ? () => water.updateReminderInterval(
                              water.reminderInterval + 1)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
        ],
    );
  }
}
