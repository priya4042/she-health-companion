import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/providers/medicine_provider.dart';
import '../../data/providers/mood_provider.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/sleep_provider.dart';
import '../../data/providers/water_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class AiInsightsScreen extends StatelessWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();
    final period = context.watch<PeriodProvider>();
    final medicine = context.watch<MedicineProvider>();
    final mood = context.watch<MoodProvider>();
    final sleep = context.watch<SleepProvider>();

    final insights = _generateInsights(water, period, medicine, mood, sleep);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Insights')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF673AB7), Color(0xFF311B92)],
              ),
              child: const Row(
                children: [
                  Text('🧠', style: TextStyle(fontSize: 36)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Smart Health Insights',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Patterns detected from your data',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),

            if (insights.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text('🔍', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 16),
                    Text(
                      'Not enough data yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keep tracking for at least a week\nto unlock personalized insights!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              )
            else
              AnimationLimiter(
                child: Column(
                  children: List.generate(insights.length, (i) {
                    final insight = insights[i];
                    return AnimationConfiguration.staggeredList(
                      position: i,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 30,
                        child: FadeInAnimation(
                          child: _buildInsightCard(insight),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateInsights(
    WaterProvider water,
    PeriodProvider period,
    MedicineProvider medicine,
    MoodProvider mood,
    SleepProvider sleep,
  ) {
    final insights = <Map<String, dynamic>>[];

    // Insight 1: Water habit
    if (water.allIntakes.length >= 3) {
      final goalMet = water.todayProgress >= 1.0;
      insights.add({
        'icon': '💧',
        'title': 'Hydration Pattern',
        'detail': goalMet
            ? 'Great! You\'re meeting your water goal consistently.'
            : 'Try drinking water before meals to boost intake.',
        'color': AppColors.waterColor,
        'tag': 'WATER',
      });
    }

    // Insight 2: Cycle prediction confidence
    if (period.records.length >= 3) {
      final avgCycle = period.averageCycleLength;
      final variance = (avgCycle - period.cycleLength).abs();
      insights.add({
        'icon': '🩸',
        'title': 'Cycle Insight',
        'detail': variance < 2
            ? 'Your cycle is very regular at ${avgCycle.toStringAsFixed(0)} days. Predictions are highly accurate.'
            : 'Your actual cycle is ${avgCycle.toStringAsFixed(0)} days, not ${period.cycleLength}. Consider updating settings.',
        'color': AppColors.periodColor,
        'tag': 'CYCLE',
        'action': variance >= 2 ? 'Update cycle length' : null,
      });
    }

    // Insight 3: Mood + Sleep correlation
    if (mood.entries.length >= 5 && sleep.records.length >= 5) {
      final goodSleep = sleep.records.where((r) => r.quality >= 4).length;
      final goodMood = mood.entries.where((e) => e.moodScore >= 4).length;
      if (goodSleep > 0 && goodMood > 0) {
        insights.add({
          'icon': '😴',
          'title': 'Sleep & Mood Link',
          'detail':
              'Your mood is ${((goodMood / mood.entries.length) * 100).round()}% positive when you sleep ${sleep.averageDuration.toStringAsFixed(1)}h+ per night.',
          'color': const Color(0xFF5C6BC0),
          'tag': 'PATTERN',
        });
      }
    }

    // Insight 4: Medicine adherence
    if (medicine.activeMedicines.isNotEmpty) {
      final rate = medicine.todayCompletionRate;
      insights.add({
        'icon': '💊',
        'title': 'Medicine Adherence',
        'detail': rate >= 0.8
            ? 'Excellent! ${(rate * 100).round()}% adherence today. Keep it up!'
            : 'Set medicine reminders 30 mins before to improve adherence.',
        'color': AppColors.medicineColor,
        'tag': 'MEDICINE',
      });
    }

    // Insight 5: Mood trend
    if (mood.entries.length >= 7) {
      final recent7 = mood.entries.take(7).toList();
      final avg = recent7.fold<double>(0, (sum, e) => sum + e.moodScore) / 7;
      if (avg >= 4) {
        insights.add({
          'icon': '🌟',
          'title': 'Mood Trending Up',
          'detail':
              'Your mood has been ${avg.toStringAsFixed(1)}/5 in the last week. You\'re thriving! Keep doing what you\'re doing.',
          'color': AppColors.moodColor,
          'tag': 'POSITIVE',
        });
      } else if (avg <= 2.5) {
        insights.add({
          'icon': '💙',
          'title': 'Self-Care Reminder',
          'detail':
              'Your mood has been low recently (${avg.toStringAsFixed(1)}/5). Try gentle yoga, calling a friend, or talking to a doctor.',
          'color': AppColors.warning,
          'tag': 'CARE',
        });
      }
    }

    // Insight 6: Period prediction
    if (period.daysUntilNextPeriod != null && period.daysUntilNextPeriod! <= 5) {
      insights.add({
        'icon': '📅',
        'title': 'Period Approaching',
        'detail':
            'Your period is expected in ${period.daysUntilNextPeriod} days. Keep pads ready and stay hydrated.',
        'color': AppColors.periodColor,
        'tag': 'UPCOMING',
      });
    }

    // Insight 7: Hydration + cycle
    if (period.isOnPeriod && water.todayProgress < 0.5) {
      insights.add({
        'icon': '💧',
        'title': 'Period Hydration',
        'detail':
            'You\'re on your period! Hydration helps reduce cramps. You\'re only at ${(water.todayProgress * 100).round()}% of goal.',
        'color': AppColors.warning,
        'tag': 'TIP',
      });
    }

    // Insight 8: Sleep quality trend
    if (sleep.records.length >= 5) {
      final avgQuality = sleep.averageQuality;
      if (avgQuality < 3) {
        insights.add({
          'icon': '😴',
          'title': 'Improve Sleep',
          'detail':
              'Your sleep quality is ${avgQuality.toStringAsFixed(1)}/5. Try: no screens 1h before bed, consistent bedtime, dark room.',
          'color': const Color(0xFF5C6BC0),
          'tag': 'SLEEP',
        });
      }
    }

    return insights;
  }

  Widget _buildInsightCard(Map<String, dynamic> insight) {
    final color = insight['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(insight['icon'] as String, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        insight['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          insight['tag'] as String,
                          style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    insight['detail'] as String,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                  ),
                  if (insight['action'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '→ ${insight['action']}',
                        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
