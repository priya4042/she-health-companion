import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../data/providers/period_provider.dart';
import '../../widgets/gradient_card.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  static const _phases = {
    'Menstrual': {
      'days': 'Days 1-5',
      'energy': 'Low',
      'color': Color(0xFFE91E63),
      'tips': 'Rest is okay. Focus on gentle movement to ease cramps.',
      'workouts': [
        {'name': 'Gentle Yoga', 'duration': '15-20 min', 'intensity': 'Low', 'desc': 'Cat-cow, child\'s pose, supine twists'},
        {'name': 'Slow Walking', 'duration': '20-30 min', 'intensity': 'Low', 'desc': 'Outdoor walk in fresh air'},
        {'name': 'Stretching', 'duration': '10-15 min', 'intensity': 'Low', 'desc': 'Hip openers, hamstring stretches'},
        {'name': 'Pelvic Tilts', 'duration': '5-10 min', 'intensity': 'Low', 'desc': 'Eases lower back pain'},
      ],
    },
    'Follicular': {
      'days': 'Days 6-13',
      'energy': 'High',
      'color': Color(0xFF66BB6A),
      'tips': 'Energy peaks! Try new workouts and push yourself.',
      'workouts': [
        {'name': 'HIIT Cardio', 'duration': '20-30 min', 'intensity': 'High', 'desc': 'Burpees, jumping jacks, mountain climbers'},
        {'name': 'Strength Training', 'duration': '30-45 min', 'intensity': 'High', 'desc': 'Lifting weights, resistance bands'},
        {'name': 'Dance Workout', 'duration': '30 min', 'intensity': 'High', 'desc': 'Zumba, Bollywood dance fitness'},
        {'name': 'Running', 'duration': '20-40 min', 'intensity': 'High', 'desc': 'Try interval running'},
      ],
    },
    'Ovulation': {
      'days': 'Days 14-16',
      'energy': 'Peak',
      'color': Color(0xFFFF9800),
      'tips': 'Maximum strength and endurance. Best week for personal records!',
      'workouts': [
        {'name': 'Heavy Lifting', 'duration': '45 min', 'intensity': 'Very High', 'desc': 'Squats, deadlifts, bench press'},
        {'name': 'Spin Class', 'duration': '45 min', 'intensity': 'Very High', 'desc': 'High intensity cycling'},
        {'name': 'Boxing/Kickboxing', 'duration': '30 min', 'intensity': 'Very High', 'desc': 'Full body cardio'},
        {'name': 'Sprint Intervals', 'duration': '20 min', 'intensity': 'Very High', 'desc': 'Maximum effort sprints'},
      ],
    },
    'Luteal': {
      'days': 'Days 17-28',
      'energy': 'Moderate to Low',
      'color': Color(0xFF9C27B0),
      'tips': 'Energy decreases. Switch to moderate workouts and self-care.',
      'workouts': [
        {'name': 'Pilates', 'duration': '30 min', 'intensity': 'Moderate', 'desc': 'Core strengthening, flexibility'},
        {'name': 'Yoga Flow', 'duration': '30 min', 'intensity': 'Moderate', 'desc': 'Vinyasa, sun salutations'},
        {'name': 'Brisk Walking', 'duration': '30-45 min', 'intensity': 'Moderate', 'desc': 'Steady-state cardio'},
        {'name': 'Bodyweight', 'duration': '20 min', 'intensity': 'Moderate', 'desc': 'Push-ups, lunges, planks'},
      ],
    },
  };

  String _getCurrentPhase(int? cycleDay, int cycleLength) {
    if (cycleDay == null) return 'Follicular';
    if (cycleDay <= 5) return 'Menstrual';
    if (cycleDay <= 13) return 'Follicular';
    if (cycleDay <= 16) return 'Ovulation';
    return 'Luteal';
  }

  @override
  Widget build(BuildContext context) {
    final period = context.watch<PeriodProvider>();
    final currentPhase = _getCurrentPhase(period.currentCycleDay, period.cycleLength);

    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Workouts')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current phase highlight
            _buildCurrentPhaseCard(currentPhase, period.currentCycleDay)
                .animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 24),

            // All phases
            const Text('All Cycle Phases', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._phases.entries.map((entry) {
              final isCurrent = entry.key == currentPhase;
              return _buildPhaseCard(context, entry.key, entry.value, isCurrent);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPhaseCard(String phaseName, int? cycleDay) {
    final phase = _phases[phaseName]!;
    final color = phase['color'] as Color;

    return GradientCard(
      gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Current Phase', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          Text(phaseName,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          Text('${phase['days']} • Energy: ${phase['energy']}',
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          Text(phase['tips'] as String,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(BuildContext context, String name, Map<String, dynamic> phase, bool isCurrent) {
    final color = phase['color'] as Color;
    final workouts = phase['workouts'] as List;

    return ExpansionTile(
      initiallyExpanded: isCurrent,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      title: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
                  Text(phase['days'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
            if (isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
      children: workouts.map<Widget>((w) {
        final workout = w as Map<String, dynamic>;
        return Container(
          margin: const EdgeInsets.only(bottom: 8, left: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.fitness_center, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(workout['desc'] as String,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 11, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Text(workout['duration'] as String,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                        const SizedBox(width: 8),
                        Icon(Icons.flash_on, size: 11, color: color),
                        const SizedBox(width: 3),
                        Text(workout['intensity'] as String,
                            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
