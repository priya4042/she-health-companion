import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../models/challenge_model.dart';

class GamificationProvider extends ChangeNotifier {
  late Box<DailyChallenge> _challengeBox;
  late Box<UserAchievement> _achievementBox;
  late Box _settingsBox;
  final _uuid = const Uuid();

  List<DailyChallenge> _challenges = [];
  List<UserAchievement> _achievements = [];

  GamificationProvider() {
    _challengeBox = Hive.box<DailyChallenge>(AppConstants.challengeBox);
    _achievementBox = Hive.box<UserAchievement>(AppConstants.achievementBox);
    _settingsBox = Hive.box(AppConstants.settingsBox);
    _ensureTodayChallenges();
    _loadData();
  }

  List<DailyChallenge> get challenges => List.unmodifiable(_challenges);
  List<UserAchievement> get achievements => List.unmodifiable(_achievements);

  List<DailyChallenge> get todayChallenges {
    final today = AppDateUtils.dateOnly(DateTime.now());
    return _challenges
        .where((c) => AppDateUtils.isSameDay(c.date, today))
        .toList();
  }

  int get todayCompletedCount =>
      todayChallenges.where((c) => c.completed).length;

  int get totalPoints {
    return _settingsBox.get('total_points', defaultValue: 0);
  }

  int get currentLevel => (totalPoints / 100).floor() + 1;

  double get levelProgress => (totalPoints % 100) / 100;

  String get levelTitle {
    if (currentLevel <= 2) return 'Beginner';
    if (currentLevel <= 5) return 'Health Explorer';
    if (currentLevel <= 10) return 'Wellness Warrior';
    if (currentLevel <= 20) return 'Health Champion';
    if (currentLevel <= 35) return 'Wellness Master';
    return 'Health Legend';
  }

  int get totalChallengesCompleted {
    return _challenges.where((c) => c.completed).length;
  }

  static const List<Map<String, dynamic>> _challengeTemplates = [
    {'title': 'Hydration Hero', 'desc': 'Drink 8 glasses of water today', 'cat': 'water', 'pts': 15},
    {'title': 'Early Bird', 'desc': 'Log your sleep before 10 AM', 'cat': 'sleep', 'pts': 10},
    {'title': 'Medicine Master', 'desc': 'Take all your medicines on time', 'cat': 'medicine', 'pts': 20},
    {'title': 'Mood Check', 'desc': 'Log your mood today', 'cat': 'mood', 'pts': 10},
    {'title': 'Super Hydrator', 'desc': 'Drink 10 glasses of water', 'cat': 'water', 'pts': 25},
    {'title': 'Zen Mode', 'desc': 'Rate your mood as Good or Great', 'cat': 'mood', 'pts': 15},
    {'title': 'Sleep Champion', 'desc': 'Get at least 7 hours of sleep', 'cat': 'sleep', 'pts': 20},
    {'title': 'Consistency King', 'desc': 'Complete all daily challenges', 'cat': 'general', 'pts': 30},
    {'title': 'Water Streak', 'desc': 'Hit water goal 3 days in a row', 'cat': 'water', 'pts': 25},
    {'title': 'Health Writer', 'desc': 'Write in your mood journal', 'cat': 'mood', 'pts': 10},
    {'title': 'Night Owl No More', 'desc': 'Sleep before 11 PM tonight', 'cat': 'sleep', 'pts': 15},
    {'title': 'Pill Perfect', 'desc': 'Don\'t miss any medicine dose', 'cat': 'medicine', 'pts': 20},
    {'title': 'Self-Care Sunday', 'desc': 'Log all health metrics today', 'cat': 'general', 'pts': 25},
    {'title': 'Aqua Champion', 'desc': 'Drink 2L of water (8+ glasses)', 'cat': 'water', 'pts': 20},
    {'title': 'Dream Tracker', 'desc': 'Rate your sleep quality today', 'cat': 'sleep', 'pts': 10},
  ];

  static const List<Map<String, String>> _achievementDefs = [
    {'id': 'first_steps', 'title': 'First Steps', 'desc': 'Complete your first challenge', 'icon': '🌱', 'pts': '0'},
    {'id': 'week_warrior', 'title': 'Week Warrior', 'desc': 'Complete 7 challenges', 'icon': '⚡', 'pts': '70'},
    {'id': 'hydration_hero', 'title': 'Hydration Hero', 'desc': 'Earn 100 points', 'icon': '💧', 'pts': '100'},
    {'id': 'health_explorer', 'title': 'Health Explorer', 'desc': 'Reach Level 3', 'icon': '🗺️', 'pts': '200'},
    {'id': 'wellness_warrior', 'title': 'Wellness Warrior', 'desc': 'Earn 500 points', 'icon': '🛡️', 'pts': '500'},
    {'id': 'champion', 'title': 'Health Champion', 'desc': 'Earn 1000 points', 'icon': '🏆', 'pts': '1000'},
    {'id': 'legend', 'title': 'Health Legend', 'desc': 'Earn 2000 points', 'icon': '👑', 'pts': '2000'},
    {'id': 'streak_3', 'title': 'On Fire', 'desc': '3-day challenge streak', 'icon': '🔥', 'pts': '50'},
    {'id': 'streak_7', 'title': 'Unstoppable', 'desc': '7-day challenge streak', 'icon': '🚀', 'pts': '150'},
    {'id': 'streak_30', 'title': 'Monthly Master', 'desc': '30-day challenge streak', 'icon': '💎', 'pts': '500'},
  ];

  void _loadData() {
    _challenges = _challengeBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    _achievements = _achievementBox.values.toList();
    notifyListeners();
  }

  Future<void> _ensureTodayChallenges() async {
    final today = AppDateUtils.dateOnly(DateTime.now());
    final hasTodayChallenges = _challengeBox.values
        .any((c) => AppDateUtils.isSameDay(c.date, today));

    if (!hasTodayChallenges) {
      // Pick 3 random challenges for today
      final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;
      final templates = List<Map<String, dynamic>>.from(_challengeTemplates);
      final selected = <Map<String, dynamic>>[];

      for (int i = 0; i < 3 && templates.isNotEmpty; i++) {
        final index = (dayOfYear + i * 7) % templates.length;
        selected.add(templates.removeAt(index % templates.length));
      }

      for (final t in selected) {
        await _challengeBox.add(DailyChallenge(
          id: _uuid.v4(),
          date: today,
          title: t['title'] as String,
          description: t['desc'] as String,
          category: t['cat'] as String,
          points: t['pts'] as int,
        ));
      }
    }
  }

  Future<void> completeChallenge(String challengeId) async {
    final index = _challenges.indexWhere((c) => c.id == challengeId);
    if (index == -1 || _challenges[index].completed) return;

    _challenges[index].completed = true;
    _challenges[index].completedAt = DateTime.now();
    await _challenges[index].save();

    // Add points
    final pts = totalPoints + _challenges[index].points;
    await _settingsBox.put('total_points', pts);

    // Check for new achievements
    await _checkAchievements();

    _loadData();
  }

  Future<void> _checkAchievements() async {
    final earnedIds = _achievements.map((a) => a.id).toSet();

    for (final def in _achievementDefs) {
      if (earnedIds.contains(def['id'])) continue;

      final requiredPts = int.parse(def['pts']!);
      bool earned = false;

      if (def['id'] == 'first_steps' && totalChallengesCompleted >= 1) {
        earned = true;
      } else if (def['id'] == 'week_warrior' && totalChallengesCompleted >= 7) {
        earned = true;
      } else if (totalPoints >= requiredPts && requiredPts > 0) {
        earned = true;
      }

      if (earned) {
        await _achievementBox.add(UserAchievement(
          id: def['id']!,
          title: def['title']!,
          description: def['desc']!,
          icon: def['icon']!,
          earnedAt: DateTime.now(),
          pointsRequired: requiredPts,
        ));
      }
    }
  }

  List<Map<String, String>> get allAchievementDefs => _achievementDefs;

  /// Award bonus points (used by daily reward, etc.)
  Future<void> addBonusPoints(int points) async {
    final newTotal = totalPoints + points;
    await _settingsBox.put('total_points', newTotal);
    await _checkAchievements();
    _loadData();
  }

  /// Spend points (used for unlocking themes/stickers)
  Future<bool> spendPoints(int points) async {
    if (totalPoints < points) return false;
    final newTotal = totalPoints - points;
    await _settingsBox.put('total_points', newTotal);
    _loadData();
    return true;
  }
}
