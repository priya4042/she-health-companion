import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  String? _selectedSign;

  static const _signs = [
    {'name': 'Aries', 'emoji': '♈', 'dates': 'Mar 21 - Apr 19'},
    {'name': 'Taurus', 'emoji': '♉', 'dates': 'Apr 20 - May 20'},
    {'name': 'Gemini', 'emoji': '♊', 'dates': 'May 21 - Jun 20'},
    {'name': 'Cancer', 'emoji': '♋', 'dates': 'Jun 21 - Jul 22'},
    {'name': 'Leo', 'emoji': '♌', 'dates': 'Jul 23 - Aug 22'},
    {'name': 'Virgo', 'emoji': '♍', 'dates': 'Aug 23 - Sep 22'},
    {'name': 'Libra', 'emoji': '♎', 'dates': 'Sep 23 - Oct 22'},
    {'name': 'Scorpio', 'emoji': '♏', 'dates': 'Oct 23 - Nov 21'},
    {'name': 'Sagittarius', 'emoji': '♐', 'dates': 'Nov 22 - Dec 21'},
    {'name': 'Capricorn', 'emoji': '♑', 'dates': 'Dec 22 - Jan 19'},
    {'name': 'Aquarius', 'emoji': '♒', 'dates': 'Jan 20 - Feb 18'},
    {'name': 'Pisces', 'emoji': '♓', 'dates': 'Feb 19 - Mar 20'},
  ];

  static const _readings = [
    {
      'health': 'Today your energy is high. Perfect day for a workout or trying a new wellness activity.',
      'tip': 'Drink 2 extra glasses of water today',
      'mood': 'Optimistic and energetic',
      'lucky': 'Apple',
    },
    {
      'health': 'Listen to your body today. It may be asking for rest. Honor what it needs.',
      'tip': 'Take a 20-minute power nap',
      'mood': 'Reflective and calm',
      'lucky': 'Chamomile tea',
    },
    {
      'health': 'Focus on nourishing meals today. Your body craves vitamins and minerals.',
      'tip': 'Add a green vegetable to every meal',
      'mood': 'Balanced and centered',
      'lucky': 'Spinach',
    },
    {
      'health': 'Stress may peak today. Practice deep breathing to stay grounded.',
      'tip': 'Try the 4-7-8 breathing technique',
      'mood': 'Need for calm',
      'lucky': 'Lavender',
    },
    {
      'health': 'Your skin is glowing today! A great day for self-care rituals.',
      'tip': 'Apply a face mask before bed',
      'mood': 'Confident and radiant',
      'lucky': 'Rose water',
    },
    {
      'health': 'Sleep is your superpower today. Aim for an early bedtime.',
      'tip': 'No screens 1 hour before bed',
      'mood': 'Peaceful and restful',
      'lucky': 'Warm milk',
    },
    {
      'health': 'A great day for emotional release. Journal your feelings.',
      'tip': 'Write 3 things you\'re grateful for',
      'mood': 'Emotional and healing',
      'lucky': 'Pink quartz',
    },
  ];

  Map<String, String> _getReading(String sign) {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final signIndex = _signs.indexWhere((s) => s['name'] == sign);
    final reading = _readings[(dayOfYear + signIndex) % _readings.length];
    return Map<String, String>.from(reading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Horoscope')),
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
                  Text('🔮', style: TextStyle(fontSize: 36)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily Health Reading',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Pick your zodiac sign',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),

            // Zodiac grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: _signs.length,
              itemBuilder: (context, i) {
                final sign = _signs[i];
                final isSelected = _selectedSign == sign['name'];
                return GestureDetector(
                  onTap: () {
                    HapticUtils.lightTap();
                    setState(() => _selectedSign = sign['name']);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(colors: [Color(0xFF673AB7), Color(0xFF9C27B0)])
                          : null,
                      color: isSelected ? null : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.grey.withValues(alpha: 0.2),
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.purple.withValues(alpha: 0.3), blurRadius: 10)]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(sign['emoji']!,
                            style: TextStyle(fontSize: 28, color: isSelected ? Colors.white : null)),
                        const SizedBox(height: 4),
                        Text(sign['name']!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : null,
                            )),
                      ],
                    ),
                  ),
                ).animate(delay: (i * 50).ms).fadeIn();
              },
            ),
            const SizedBox(height: 20),

            // Reading
            if (_selectedSign != null) _buildReading(_selectedSign!),
          ],
        ),
      ),
    );
  }

  Widget _buildReading(String sign) {
    final reading = _getReading(sign);
    return Column(
      key: ValueKey(sign),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text('Health Reading for $sign',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              Text(reading['health']!,
                  style: const TextStyle(fontSize: 14, height: 1.5)),
            ],
          ),
        ).animate(key: ValueKey('$sign-1')).fadeIn().slideY(begin: 0.1),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Icon(Icons.tips_and_updates, color: AppColors.moodColor, size: 22),
                    const SizedBox(height: 6),
                    const Text('Tip', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(reading['tip']!,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Icon(Icons.star, color: AppColors.moodColor, size: 22),
                    const SizedBox(height: 6),
                    const Text('Lucky', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(reading['lucky']!,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.mood, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Today\'s Mood',
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text(reading['mood']!,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}
