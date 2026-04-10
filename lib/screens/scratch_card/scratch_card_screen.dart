import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/gamification_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class ScratchCardScreen extends StatefulWidget {
  const ScratchCardScreen({super.key});

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  final _settingsBox = Hive.box(AppConstants.settingsBox);
  bool _scratched = false;
  bool _claimedToday = false;
  Map<String, dynamic>? _prize;

  static const _prizes = [
    {'icon': '💎', 'title': 'JACKPOT!', 'desc': '+100 points', 'value': 100, 'color': Color(0xFFE91E63)},
    {'icon': '⭐', 'title': 'Lucky Day!', 'desc': '+50 points', 'value': 50, 'color': Color(0xFFFFD700)},
    {'icon': '🎁', 'title': 'Bonus!', 'desc': '+30 points', 'value': 30, 'color': Color(0xFFAB47BC)},
    {'icon': '🌟', 'title': 'Nice!', 'desc': '+20 points', 'value': 20, 'color': Color(0xFF42A5F5)},
    {'icon': '✨', 'title': 'Sweet!', 'desc': '+15 points', 'value': 15, 'color': Color(0xFF66BB6A)},
    {'icon': '🍀', 'title': 'Lucky!', 'desc': '+10 points', 'value': 10, 'color': Color(0xFFFF9800)},
  ];

  @override
  void initState() {
    super.initState();
    final lastClaimStr = _settingsBox.get('last_scratch');
    if (lastClaimStr != null) {
      final lastClaim = DateTime.parse(lastClaimStr as String);
      _claimedToday = AppDateUtils.isSameDay(lastClaim, DateTime.now());
    }
  }

  Future<void> _scratch(GamificationProvider game) async {
    if (_scratched || _claimedToday) return;

    HapticUtils.heavyTap();
    final random = Random();
    // Weighted random — bigger prizes are rarer
    final weights = [1, 3, 5, 8, 12, 15];
    final totalWeight = weights.reduce((a, b) => a + b);
    int roll = random.nextInt(totalWeight);
    int selectedIndex = 0;
    int cumulative = 0;
    for (int i = 0; i < weights.length; i++) {
      cumulative += weights[i];
      if (roll < cumulative) {
        selectedIndex = i;
        break;
      }
    }

    setState(() {
      _scratched = true;
      _prize = Map<String, dynamic>.from(_prizes[selectedIndex]);
    });

    await game.addBonusPoints(_prize!['value'] as int);
    await _settingsBox.put('last_scratch', DateTime.now().toIso8601String());

    if (mounted) {
      setState(() => _claimedToday = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GamificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Scratch Card')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFAB47BC)],
              ),
              child: const Row(
                children: [
                  Text('🎫', style: TextStyle(fontSize: 36)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily Scratch Card',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Scratch to win mystery prizes!',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 32),

            // Scratch card
            GestureDetector(
              onTap: _scratched || _claimedToday ? null : () => _scratch(game),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: _scratched && _prize != null
                      ? LinearGradient(
                          colors: [
                            _prize!['color'] as Color,
                            (_prize!['color'] as Color).withValues(alpha: 0.6),
                          ],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: (_scratched && _prize != null
                              ? _prize!['color'] as Color
                              : const Color(0xFFFFD700))
                          .withValues(alpha: 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: _scratched && _prize != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _prize!['icon'] as String,
                              style: const TextStyle(fontSize: 80),
                            ).animate().scale(
                                begin: const Offset(0.3, 0.3),
                                duration: 600.ms,
                                curve: Curves.elasticOut),
                            const SizedBox(height: 16),
                            Text(
                              _prize!['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().fadeIn(delay: 300.ms),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _prize!['desc'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ).animate().fadeIn(delay: 500.ms),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _claimedToday ? Icons.check_circle : Icons.touch_app,
                              size: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _claimedToday ? 'Already Scratched!' : 'TAP TO SCRATCH',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _claimedToday ? 'Come back tomorrow' : 'Reveal your prize',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text('${game.totalPoints} points',
                      style: const TextStyle(
                          color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Possible Prizes',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: _prizes.map((p) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (p['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(p['icon'] as String, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(p['desc'] as String,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: p['color'] as Color)),
                          ],
                        ),
                      );
                    }).toList(),
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
