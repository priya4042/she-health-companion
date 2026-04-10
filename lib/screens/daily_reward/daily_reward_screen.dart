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

class DailyRewardScreen extends StatefulWidget {
  const DailyRewardScreen({super.key});

  @override
  State<DailyRewardScreen> createState() => _DailyRewardScreenState();
}

class _DailyRewardScreenState extends State<DailyRewardScreen> {
  final _settingsBox = Hive.box(AppConstants.settingsBox);
  bool _claimedToday = false;
  int _streak = 0;
  Set<String> _unlockedStickers = {};

  static const _stickers = [
    {'emoji': '🌸', 'name': 'Cherry Blossom', 'cost': 0},
    {'emoji': '⭐', 'name': 'Star', 'cost': 0},
    {'emoji': '💖', 'name': 'Sparkle Heart', 'cost': 10},
    {'emoji': '🦋', 'name': 'Butterfly', 'cost': 15},
    {'emoji': '🌈', 'name': 'Rainbow', 'cost': 20},
    {'emoji': '🌙', 'name': 'Moon', 'cost': 25},
    {'emoji': '☀️', 'name': 'Sun', 'cost': 30},
    {'emoji': '🌹', 'name': 'Rose', 'cost': 40},
    {'emoji': '👑', 'name': 'Crown', 'cost': 50},
    {'emoji': '💎', 'name': 'Diamond', 'cost': 75},
    {'emoji': '🦄', 'name': 'Unicorn', 'cost': 100},
    {'emoji': '🌟', 'name': 'Glowing Star', 'cost': 150},
  ];

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  void _loadStatus() {
    final lastClaimStr = _settingsBox.get('last_reward_claim');
    if (lastClaimStr != null) {
      final lastClaim = DateTime.parse(lastClaimStr as String);
      _claimedToday = AppDateUtils.isSameDay(lastClaim, DateTime.now());
    }
    _streak = _settingsBox.get('reward_streak', defaultValue: 0);
    final stickers = _settingsBox.get('unlocked_stickers', defaultValue: <String>['Cherry Blossom', 'Star']);
    _unlockedStickers = (stickers as List).map((e) => e as String).toSet();
    setState(() {});
  }

  Future<void> _claimReward(GamificationProvider game) async {
    HapticUtils.success();

    // Check streak
    final lastClaimStr = _settingsBox.get('last_reward_claim');
    if (lastClaimStr != null) {
      final lastClaim = DateTime.parse(lastClaimStr as String);
      final daysSince = DateTime.now().difference(lastClaim).inDays;
      if (daysSince == 1) {
        _streak++;
      } else if (daysSince > 1) {
        _streak = 1;
      }
    } else {
      _streak = 1;
    }

    final reward = _streak * 5; // 5, 10, 15, 20...

    await _settingsBox.put('last_reward_claim', DateTime.now().toIso8601String());
    await _settingsBox.put('reward_streak', _streak);

    // Add points to gamification
    final currentPoints = game.totalPoints;
    await _settingsBox.put('total_points', currentPoints + reward);

    setState(() => _claimedToday = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 +$reward points! Day $_streak streak'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _unlockSticker(Map<String, dynamic> sticker, GamificationProvider game) async {
    final cost = sticker['cost'] as int;
    if (game.totalPoints < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Need $cost points (you have ${game.totalPoints})')),
      );
      return;
    }

    HapticUtils.success();
    _unlockedStickers.add(sticker['name'] as String);
    await _settingsBox.put('unlocked_stickers', _unlockedStickers.toList());
    await _settingsBox.put('total_points', game.totalPoints - cost);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GamificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Reward')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Reward card
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFF9800)],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    _claimedToday ? '✅' : '🎁',
                    style: const TextStyle(fontSize: 64),
                  ).animate(onPlay: (c) => c.repeat())
                      .moveY(begin: 0, end: -6, duration: 1500.ms, curve: Curves.easeInOut)
                      .then()
                      .moveY(begin: -6, end: 0, duration: 1500.ms, curve: Curves.easeInOut),
                  const SizedBox(height: 16),
                  Text(
                    _claimedToday ? 'Already claimed today!' : 'Claim your daily reward',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _claimedToday
                        ? 'Come back tomorrow!'
                        : 'Earn ${(_streak + 1) * 5} points today',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  if (!_claimedToday)
                    ElevatedButton.icon(
                      onPressed: () => _claimReward(game),
                      icon: const Icon(Icons.card_giftcard),
                      label: const Text('Claim Reward'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF9800),
                      ),
                    ),
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
            const SizedBox(height: 16),

            // Streak
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Check-in Streak', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('$_streak days',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.streakColor)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${game.totalPoints} pts',
                        style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 24),

            // Sticker collection
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Sticker Collection',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: _stickers.length,
              itemBuilder: (context, i) {
                final sticker = _stickers[i];
                final unlocked = _unlockedStickers.contains(sticker['name']);
                final canAfford = game.totalPoints >= (sticker['cost'] as int);

                return GestureDetector(
                  onTap: unlocked ? null : () => _unlockSticker(sticker, game),
                  child: Container(
                    decoration: BoxDecoration(
                      color: unlocked
                          ? AppColors.moodColor.withValues(alpha: 0.1)
                          : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: unlocked
                            ? AppColors.moodColor.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: unlocked ? 1.0 : 0.3,
                                child: Text(sticker['emoji'] as String, style: const TextStyle(fontSize: 36)),
                              ),
                              const SizedBox(height: 4),
                              Text(sticker['name'] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: unlocked ? null : Colors.grey,
                                  ),
                                  textAlign: TextAlign.center),
                              if (!unlocked)
                                Text('${sticker['cost']} pts',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: canAfford ? AppColors.success : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    )),
                            ],
                          ),
                        ),
                        if (unlocked)
                          const Positioned(
                            top: 4, right: 4,
                            child: Icon(Icons.check_circle, color: AppColors.success, size: 16),
                          ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (i * 50).ms);
              },
            ),
          ],
        ),
      ),
    );
  }
}
