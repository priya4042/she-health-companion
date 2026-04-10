import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../data/providers/mood_provider.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/sleep_provider.dart';
import '../../data/providers/water_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class MemoryLaneScreen extends StatelessWidget {
  const MemoryLaneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();
    final period = context.watch<PeriodProvider>();
    final sleep = context.watch<SleepProvider>();
    final mood = context.watch<MoodProvider>();

    final today = DateTime.now();
    final memories = _gatherMemories(today, water, period, sleep, mood);

    return Scaffold(
      appBar: AppBar(title: const Text('Memory Lane')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFAB47BC), Color(0xFF6A1B9A)],
              ),
              child: Row(
                children: [
                  const Text('🕰️', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('On This Day',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(AppDateUtils.formatDate(today),
                            style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 24),

            if (memories.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Text('🌱', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 16),
                    Text(
                      'No memories yet from past years',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keep tracking your health!\nYour memories will appear here next year.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              )
            else
              ...memories.asMap().entries.map((entry) {
                final i = entry.key;
                final memory = entry.value;
                return _buildMemoryCard(memory, i);
              }),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _gatherMemories(
      DateTime today, WaterProvider water, PeriodProvider period, SleepProvider sleep, MoodProvider mood) {
    final memories = <Map<String, dynamic>>[];

    // Look back 1, 2, 3 years
    for (int yearsBack = 1; yearsBack <= 3; yearsBack++) {
      final pastDate = DateTime(today.year - yearsBack, today.month, today.day);

      // Water on this day
      final waterOnDay = water.allIntakes
          .where((i) => AppDateUtils.isSameDay(i.date, pastDate))
          .fold<int>(0, (sum, i) => sum + i.glasses);
      if (waterOnDay > 0) {
        memories.add({
          'years': yearsBack,
          'icon': '💧',
          'title': '$waterOnDay glasses of water',
          'date': pastDate,
          'color': AppColors.waterColor,
        });
      }

      // Period on this day
      for (final record in period.records) {
        if (AppDateUtils.isSameDay(record.startDate, pastDate)) {
          memories.add({
            'years': yearsBack,
            'icon': '🩸',
            'title': 'Your period started',
            'date': pastDate,
            'color': AppColors.periodColor,
          });
        }
      }

      // Sleep on this day
      final sleepOnDay = sleep.records.where((r) => AppDateUtils.isSameDay(r.date, pastDate)).firstOrNull;
      if (sleepOnDay != null) {
        memories.add({
          'years': yearsBack,
          'icon': '😴',
          'title': 'You slept ${sleepOnDay.durationFormatted}',
          'subtitle': '${sleepOnDay.qualityLabel} quality',
          'date': pastDate,
          'color': const Color(0xFF5C6BC0),
        });
      }

      // Mood on this day
      final moodOnDay = mood.entries.where((e) => AppDateUtils.isSameDay(e.date, pastDate)).firstOrNull;
      if (moodOnDay != null) {
        memories.add({
          'years': yearsBack,
          'icon': moodOnDay.emoji,
          'title': 'Felt ${moodOnDay.moodLabel}',
          'subtitle': moodOnDay.journalText,
          'date': pastDate,
          'color': AppColors.moodColor,
        });
      }
    }

    return memories;
  }

  Widget _buildMemoryCard(Map<String, dynamic> memory, int index) {
    final years = memory['years'] as int;
    final color = memory['color'] as Color;
    final subtitle = memory['subtitle'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(memory['icon'] as String, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      years == 1 ? '1 year ago' : '$years years ago',
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    memory['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
  }
}
