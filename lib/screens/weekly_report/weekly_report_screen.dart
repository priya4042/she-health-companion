import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/medicine_provider.dart';
import '../../data/providers/mood_provider.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/sleep_provider.dart';
import '../../data/providers/streak_provider.dart';
import '../../data/providers/water_provider.dart';
import '../../widgets/gradient_card.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();
    final medicine = context.watch<MedicineProvider>();
    final mood = context.watch<MoodProvider>();
    final sleep = context.watch<SleepProvider>();
    final streak = context.watch<StreakProvider>();
    final period = context.watch<PeriodProvider>();

    // Calculate scores
    final waterScore = _calcWaterScore(water);
    final medScore = (medicine.todayCompletionRate * 100).round();
    final moodScore = (mood.averageMoodScore * 20).round();
    final sleepScore = _calcSleepScore(sleep);
    final totalScore = ((waterScore + medScore + moodScore + sleepScore) / 4).round();

    String grade;
    Color gradeColor;
    String emoji;
    if (totalScore >= 80) { grade = 'A+'; gradeColor = AppColors.success; emoji = '🌟'; }
    else if (totalScore >= 70) { grade = 'A'; gradeColor = AppColors.success; emoji = '😊'; }
    else if (totalScore >= 60) { grade = 'B'; gradeColor = AppColors.waterColor; emoji = '👍'; }
    else if (totalScore >= 40) { grade = 'C'; gradeColor = AppColors.warning; emoji = '💪'; }
    else { grade = 'D'; gradeColor = AppColors.error; emoji = '📈'; }

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Report Card')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Report card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [gradeColor, gradeColor.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: gradeColor.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  const Text('Weekly Health Score', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 48)),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          Text(grade, style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold)),
                          Text('$totalScore / 100', style: const TextStyle(color: Colors.white70, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getMotivation(totalScore),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Week of ${AppDateUtils.formatDate(DateTime.now().subtract(const Duration(days: 7)))}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
            const SizedBox(height: 24),

            // Category breakdown
            _buildScoreRow('💧 Water Intake', waterScore, AppColors.waterColor)
                .animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
            _buildScoreRow('💊 Medicine Adherence', medScore, AppColors.medicineColor)
                .animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
            _buildScoreRow('😊 Mood Average', moodScore, AppColors.moodColor)
                .animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
            _buildScoreRow('😴 Sleep Quality', sleepScore, const Color(0xFF5C6BC0))
                .animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
            const SizedBox(height: 20),

            // Streaks
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StreakBadge(emoji: '💧', value: streak.getStreak('water'), label: 'Water'),
                  _StreakBadge(emoji: '💊', value: streak.getStreak('medicine'), label: 'Medicine'),
                  _StreakBadge(emoji: '😊', value: mood.moodStreak, label: 'Mood'),
                  _StreakBadge(emoji: '😴', value: sleep.sleepStreak, label: 'Sleep'),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 24),

            // Period info
            if (period.daysUntilNextPeriod != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.periodColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.periodColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Text('🩸', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Text(
                      period.isOnPeriod
                          ? 'Currently on period (Day ${period.currentCycleDay})'
                          : 'Next period in ${period.daysUntilNextPeriod} days',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 24),

            // Share button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareOnWhatsApp(context, totalScore, grade),
                icon: const Icon(Icons.share),
                label: const Text('Share on WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ).animate().fadeIn(delay: 700.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, int score, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$score',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calcWaterScore(WaterProvider water) {
    final weeklyData = water.weeklyData;
    if (weeklyData.isEmpty) return 0;
    int daysGoalMet = weeklyData.values.where((v) => v >= water.dailyGoal).length;
    return ((daysGoalMet / 7) * 100).round();
  }

  int _calcSleepScore(SleepProvider sleep) {
    if (sleep.records.isEmpty) return 0;
    final avgQuality = sleep.averageQuality;
    return (avgQuality * 20).round();
  }

  String _getMotivation(int score) {
    if (score >= 80) return 'Outstanding week! You\'re taking amazing care of yourself! 🎉';
    if (score >= 60) return 'Good progress this week! Keep pushing for excellence! 💪';
    if (score >= 40) return 'You\'re building healthy habits. Every step counts! 🌱';
    return 'New week, new start! Focus on one habit at a time. You got this! ❤️';
  }

  Future<void> _shareOnWhatsApp(BuildContext context, int score, String grade) async {
    HapticUtils.lightTap();
    final message = '📊 My Weekly Health Report Card\n\n'
        '🏆 Grade: $grade ($score/100)\n\n'
        'Tracked with Daily Life Helper app\n'
        '- Period, Water, Medicine, Sleep & Mood tracking\n'
        '- Home remedies & health tips\n\n'
        'Download now and start your health journey! 💪';

    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _StreakBadge extends StatelessWidget {
  final String emoji;
  final int value;
  final String label;

  const _StreakBadge({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }
}
