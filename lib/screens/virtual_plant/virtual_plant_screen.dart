import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/providers/gamification_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class VirtualPlantScreen extends StatelessWidget {
  const VirtualPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GamificationProvider>();
    final points = game.totalPoints;

    final stage = _getPlantStage(points);
    final nextStage = _getNextStage(stage);
    final progress = _getStageProgress(points);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Health Plant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Plant display
            GradientCard(
              gradient: LinearGradient(colors: [
                stage['color'] as Color,
                (stage['color'] as Color).withValues(alpha: 0.7),
              ]),
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(stage['emoji'] as String,
                      style: const TextStyle(fontSize: 100))
                      .animate(onPlay: (c) => c.repeat())
                      .moveY(begin: 0, end: -8, duration: 2000.ms, curve: Curves.easeInOut)
                      .then()
                      .moveY(begin: -8, end: 0, duration: 2000.ms, curve: Curves.easeInOut),
                  const SizedBox(height: 16),
                  Text(stage['name'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(stage['description'] as String,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      textAlign: TextAlign.center),
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
            const SizedBox(height: 20),

            // Progress to next stage
            if (nextStage != null)
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Next Stage', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text(nextStage['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.success.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation(AppColors.success),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(nextStage['minPoints'] as int) - points} points to grow',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 20),

            // All stages
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Growth Journey', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            ..._stages.map((s) {
              final unlocked = points >= (s['minPoints'] as int);
              final isCurrent = s['name'] == stage['name'];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? (s['color'] as Color).withValues(alpha: 0.15)
                      : Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                  border: isCurrent
                      ? Border.all(color: s['color'] as Color, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    Opacity(
                      opacity: unlocked ? 1.0 : 0.3,
                      child: Text(s['emoji'] as String, style: const TextStyle(fontSize: 36)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['name'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: unlocked ? null : Colors.grey,
                              )),
                          Text('${s['minPoints']} points',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    if (unlocked)
                      Icon(Icons.check_circle, color: s['color'] as Color, size: 20)
                    else
                      const Icon(Icons.lock, color: Colors.grey, size: 18),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  static const List<Map<String, dynamic>> _stages = [
    {'name': 'Seed', 'emoji': '🌱', 'minPoints': 0, 'color': Color(0xFF8BC34A),
      'description': 'Your journey begins. Complete challenges to grow!'},
    {'name': 'Sprout', 'emoji': '🌿', 'minPoints': 50, 'color': Color(0xFF66BB6A),
      'description': 'Starting to grow! Keep up the good work.'},
    {'name': 'Sapling', 'emoji': '🪴', 'minPoints': 150, 'color': Color(0xFF4CAF50),
      'description': 'Growing strong with your healthy habits.'},
    {'name': 'Young Plant', 'emoji': '🌳', 'minPoints': 300, 'color': Color(0xFF388E3C),
      'description': 'You\'re building lasting wellness habits.'},
    {'name': 'Blossoming', 'emoji': '🌸', 'minPoints': 500, 'color': Color(0xFFEC407A),
      'description': 'Your dedication is blooming beautifully!'},
    {'name': 'Flowering Tree', 'emoji': '🌺', 'minPoints': 800, 'color': Color(0xFFE91E63),
      'description': 'A beautiful tree full of life and health.'},
    {'name': 'Magical Garden', 'emoji': '🌷', 'minPoints': 1200, 'color': Color(0xFFAB47BC),
      'description': 'Your wellness garden is thriving!'},
    {'name': 'Enchanted Forest', 'emoji': '🌲', 'minPoints': 2000, 'color': Color(0xFF388E3C),
      'description': 'You are a master of self-care.'},
  ];

  Map<String, dynamic> _getPlantStage(int points) {
    Map<String, dynamic> current = _stages.first;
    for (final s in _stages) {
      if (points >= (s['minPoints'] as int)) current = s;
    }
    return current;
  }

  Map<String, dynamic>? _getNextStage(Map<String, dynamic> current) {
    final currentIndex = _stages.indexOf(current);
    if (currentIndex >= _stages.length - 1) return null;
    return _stages[currentIndex + 1];
  }

  double _getStageProgress(int points) {
    final current = _getPlantStage(points);
    final next = _getNextStage(current);
    if (next == null) return 1.0;
    final currentMin = current['minPoints'] as int;
    final nextMin = next['minPoints'] as int;
    return ((points - currentMin) / (nextMin - currentMin)).clamp(0.0, 1.0);
  }
}
