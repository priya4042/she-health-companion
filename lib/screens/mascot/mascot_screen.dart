import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/gamification_provider.dart';
import '../../data/providers/medicine_provider.dart';
import '../../data/providers/streak_provider.dart';
import '../../data/providers/water_provider.dart';

class MascotScreen extends StatefulWidget {
  const MascotScreen({super.key});

  @override
  State<MascotScreen> createState() => _MascotScreenState();
}

class _MascotScreenState extends State<MascotScreen> {
  int _interactionCount = 0;

  Map<String, dynamic> _getMascotState(int healthScore) {
    if (healthScore >= 80) {
      return {
        'emoji': '🥰',
        'name': 'Bloomy',
        'mood': 'Loving Life!',
        'message': 'You\'re crushing it! I\'m so proud of you 💖',
        'color': const Color(0xFFE91E63),
        'background': const LinearGradient(colors: [Color(0xFFFFB6E1), Color(0xFFE91E63)]),
      };
    } else if (healthScore >= 60) {
      return {
        'emoji': '😊',
        'name': 'Bloomy',
        'mood': 'Happy',
        'message': 'You\'re doing great! Keep it up 🌸',
        'color': const Color(0xFFFF9800),
        'background': const LinearGradient(colors: [Color(0xFFFFCC80), Color(0xFFFF9800)]),
      };
    } else if (healthScore >= 40) {
      return {
        'emoji': '😐',
        'name': 'Bloomy',
        'mood': 'Okay',
        'message': 'I\'m a little tired. Can we drink some water? 💧',
        'color': const Color(0xFFFFA726),
        'background': const LinearGradient(colors: [Color(0xFFFFE0B2), Color(0xFFFFA726)]),
      };
    } else if (healthScore >= 20) {
      return {
        'emoji': '😟',
        'name': 'Bloomy',
        'mood': 'Sad',
        'message': 'I miss you... please come back and care for me 🥺',
        'color': const Color(0xFF7E57C2),
        'background': const LinearGradient(colors: [Color(0xFFD1C4E9), Color(0xFF7E57C2)]),
      };
    } else {
      return {
        'emoji': '😢',
        'name': 'Bloomy',
        'mood': 'Crying',
        'message': 'I\'m so lonely. Please track your health today! 💔',
        'color': const Color(0xFF5C6BC0),
        'background': const LinearGradient(colors: [Color(0xFFC5CAE9), Color(0xFF5C6BC0)]),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();
    final medicine = context.watch<MedicineProvider>();
    final streak = context.watch<StreakProvider>();
    final game = context.watch<GamificationProvider>();

    final waterPct = water.todayProgress * 100;
    final medPct = medicine.todayCompletionRate * 100;
    final waterStreak = streak.getStreak('water');
    final medStreak = streak.getStreak('medicine');

    final healthScore = ((waterPct + medPct + (waterStreak * 5) + (medStreak * 5))
        .clamp(0.0, 100.0))
        .toInt();

    final mascot = _getMascotState(healthScore);
    final gradient = mascot['background'] as LinearGradient;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloomy'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Mascot
                GestureDetector(
                  onTap: () {
                    HapticUtils.lightTap();
                    setState(() => _interactionCount++);
                  },
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.3),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        mascot['emoji'] as String,
                        style: const TextStyle(fontSize: 130),
                      ),
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .moveY(begin: 0, end: -8, duration: 2000.ms, curve: Curves.easeInOut)
                    .then()
                    .moveY(begin: -8, end: 0, duration: 2000.ms, curve: Curves.easeInOut),

                if (_interactionCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _getInteractionMessage(_interactionCount),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ).animate().fadeIn(),
                  ),
                const SizedBox(height: 24),

                Text(
                  mascot['name'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ).animate().fadeIn(),
                Text(
                  mascot['mood'] as String,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 24),

                // Speech bubble
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15),
                    ],
                  ),
                  child: Text(
                    mascot['message'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 24),

                // Health stats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Bloomy\'s Happiness',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        children: [
                          Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            height: 16,
                            width: MediaQuery.of(context).size.width * (healthScore / 100) * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('$healthScore / 100',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 16),

                // Tasks to please mascot
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bloomy needs:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 10),
                      _buildTaskRow('💧 Water', water.todayProgress >= 1.0),
                      _buildTaskRow('💊 Medicines', medicine.todayCompletionRate >= 1.0),
                      _buildTaskRow('🔥 Streaks', waterStreak >= 3 || medStreak >= 3),
                      _buildTaskRow('⭐ Points', game.totalPoints > 50),
                    ],
                  ),
                ).animate().fadeIn(delay: 700.ms),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskRow(String label, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? AppColors.success : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: done ? AppColors.success : Colors.grey.shade600,
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getInteractionMessage(int count) {
    if (count < 3) return '*giggles* That tickles!';
    if (count < 6) return '*purrs* I love your attention 💕';
    if (count < 10) return '*spins around* You\'re my favorite!';
    return '*hugs you tight* 🥰';
  }
}
