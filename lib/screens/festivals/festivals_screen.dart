import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../data/providers/period_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class FestivalsScreen extends StatelessWidget {
  const FestivalsScreen({super.key});

  static List<Map<String, dynamic>> get _festivals {
    final year = DateTime.now().year;
    return [
      {'name': 'Makar Sankranti', 'date': DateTime(year, 1, 14), 'emoji': '🪁', 'desc': 'Harvest festival'},
      {'name': 'Republic Day', 'date': DateTime(year, 1, 26), 'emoji': '🇮🇳', 'desc': 'National holiday'},
      {'name': 'Vasant Panchami', 'date': DateTime(year, 2, 14), 'emoji': '📚', 'desc': 'Goddess Saraswati'},
      {'name': 'Maha Shivratri', 'date': DateTime(year, 3, 8), 'emoji': '🕉️', 'desc': 'Lord Shiva\'s night, fasting'},
      {'name': 'Holi', 'date': DateTime(year, 3, 14), 'emoji': '🎨', 'desc': 'Festival of colors'},
      {'name': 'Ram Navami', 'date': DateTime(year, 4, 6), 'emoji': '🙏', 'desc': 'Lord Rama\'s birthday'},
      {'name': 'Eid al-Fitr', 'date': DateTime(year, 4, 10), 'emoji': '🌙', 'desc': 'End of Ramadan'},
      {'name': 'Hanuman Jayanti', 'date': DateTime(year, 4, 12), 'emoji': '🐒', 'desc': 'Hanuman\'s birthday'},
      {'name': 'Akshaya Tritiya', 'date': DateTime(year, 5, 10), 'emoji': '✨', 'desc': 'Auspicious day'},
      {'name': 'Raksha Bandhan', 'date': DateTime(year, 8, 19), 'emoji': '🎀', 'desc': 'Brother-sister bond'},
      {'name': 'Janmashtami', 'date': DateTime(year, 8, 26), 'emoji': '🦚', 'desc': 'Lord Krishna\'s birthday'},
      {'name': 'Ganesh Chaturthi', 'date': DateTime(year, 9, 7), 'emoji': '🐘', 'desc': 'Lord Ganesha festival'},
      {'name': 'Navratri', 'date': DateTime(year, 10, 3), 'emoji': '💃', 'desc': '9 nights, fasting'},
      {'name': 'Dussehra', 'date': DateTime(year, 10, 12), 'emoji': '🏹', 'desc': 'Victory of good over evil'},
      {'name': 'Karwa Chauth', 'date': DateTime(year, 10, 20), 'emoji': '🌕', 'desc': 'Wives fast for husbands'},
      {'name': 'Diwali', 'date': DateTime(year, 11, 1), 'emoji': '🪔', 'desc': 'Festival of lights'},
      {'name': 'Bhai Dooj', 'date': DateTime(year, 11, 3), 'emoji': '✨', 'desc': 'Brother-sister day'},
      {'name': 'Chhath Puja', 'date': DateTime(year, 11, 7), 'emoji': '☀️', 'desc': 'Sun worship, fasting'},
      {'name': 'Christmas', 'date': DateTime(year, 12, 25), 'emoji': '🎄', 'desc': 'Christian celebration'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final period = context.watch<PeriodProvider>();
    final upcoming = _festivals.where((f) => (f['date'] as DateTime).isAfter(DateTime.now())).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Festival Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFE63946)],
              ),
              child: const Row(
                children: [
                  Text('🎉', style: TextStyle(fontSize: 36)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Indian Festival Calendar',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Plan around your cycle',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),

            const Text('Upcoming Festivals',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),

            if (upcoming.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text('No more festivals this year. Check back in January!',
                      style: TextStyle(color: Colors.grey.shade500)),
                ),
              )
            else
              AnimationLimiter(
                child: Column(
                  children: List.generate(upcoming.length.clamp(0, 12), (i) {
                    final festival = upcoming[i];
                    final date = festival['date'] as DateTime;
                    final daysUntil = date.difference(DateTime.now()).inDays;
                    final periodOnFestival = period.isPeriodDay(date) || period.isPredictedPeriodDay(date);

                    return AnimationConfiguration.staggeredList(
                      position: i,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 30,
                        child: FadeInAnimation(
                          child: GlassCard(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 56, height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.moodColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(festival['emoji'] as String, style: const TextStyle(fontSize: 32)),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(festival['name'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text(festival['desc'] as String,
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                                      Row(
                                        children: [
                                          Text(AppDateUtils.formatDate(date),
                                              style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 8),
                                          if (daysUntil <= 7)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.success.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text('In $daysUntil days',
                                                  style: const TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                                            ),
                                        ],
                                      ),
                                      if (periodOnFestival)
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.periodColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.warning_amber, size: 11, color: AppColors.periodColor),
                                              SizedBox(width: 3),
                                              Text('Period likely on this day',
                                                  style: TextStyle(fontSize: 10, color: AppColors.periodColor, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
}
