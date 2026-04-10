import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class AffirmationsScreen extends StatefulWidget {
  const AffirmationsScreen({super.key});

  @override
  State<AffirmationsScreen> createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  final _settingsBox = Hive.box(AppConstants.settingsBox);
  int _currentIndex = 0;
  Set<int> _favorites = {};

  static const _affirmations = [
    'I am strong, beautiful, and worthy of love.',
    'My body is amazing and deserves my respect.',
    'I trust my body to guide me through every cycle.',
    'I am in control of my health and happiness.',
    'I choose self-care over self-criticism.',
    'My period is a sign of my body\'s wisdom.',
    'I am perfect just the way I am.',
    'I deserve rest, healing, and joy.',
    'My body is healing and renewing every day.',
    'I am proud of how far I have come.',
    'I attract positivity and good health.',
    'I honor my body\'s needs.',
    'Every challenge makes me stronger.',
    'I am enough, exactly as I am.',
    'I radiate confidence and positivity.',
    'My health is my greatest wealth.',
    'I choose foods that nourish my body.',
    'I am grateful for my body\'s strength.',
    'I deserve a happy, healthy life.',
    'I am surrounded by love and light.',
    'My mind is calm, my body is strong.',
    'I forgive myself and grow.',
    'I am the author of my own story.',
    'I trust the timing of my life.',
    'I am worthy of all the good things.',
    'My body knows how to heal itself.',
    'I welcome positive energy into my life.',
    'I am beautiful, inside and out.',
    'Self-love is my superpower.',
    'I am exactly where I need to be.',
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    _currentIndex = dayOfYear % _affirmations.length;
  }

  void _loadFavorites() {
    final raw = _settingsBox.get('favorite_affirmations', defaultValue: <int>[]);
    _favorites = (raw as List).map((e) => e as int).toSet();
    setState(() {});
  }

  void _toggleFavorite() {
    HapticUtils.lightTap();
    setState(() {
      if (_favorites.contains(_currentIndex)) {
        _favorites.remove(_currentIndex);
      } else {
        _favorites.add(_currentIndex);
      }
    });
    _settingsBox.put('favorite_affirmations', _favorites.toList());
  }

  void _next() {
    HapticUtils.selection();
    setState(() => _currentIndex = (_currentIndex + 1) % _affirmations.length);
  }

  void _previous() {
    HapticUtils.selection();
    setState(() => _currentIndex = (_currentIndex - 1 + _affirmations.length) % _affirmations.length);
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = _favorites.contains(_currentIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Affirmations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => _showFavorites(context),
            tooltip: 'Favorites (${_favorites.length})',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Today\'s Affirmation',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 20),

            // Main affirmation card
            GradientCard(
              key: ValueKey(_currentIndex),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFC850C0), Color(0xFF4158D0)],
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Icon(Icons.format_quote, color: Colors.white70, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    _affirmations[_currentIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${_affirmations.length}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ).animate(key: ValueKey(_currentIndex)).fadeIn().scale(begin: const Offset(0.9, 0.9)),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.arrow_back_ios_rounded,
                  label: 'Previous',
                  onTap: _previous,
                ),
                _ActionButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: isFavorite ? 'Saved' : 'Save',
                  color: isFavorite ? AppColors.primary : null,
                  onTap: _toggleFavorite,
                ),
                _ActionButton(
                  icon: Icons.arrow_forward_ios_rounded,
                  label: 'Next',
                  onTap: _next,
                ),
              ],
            ),
            const SizedBox(height: 24),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.tips_and_updates_rounded, color: AppColors.moodColor, size: 28),
                  const SizedBox(height: 8),
                  const Text('How to Practice',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    'Read the affirmation 3 times, slowly.\nClose your eyes and feel its meaning.\nRepeat throughout your day.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  void _showFavorites(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (_, scroll) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Your Favorites', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: _favorites.isEmpty
                  ? const Center(child: Text('No favorites yet. Tap the heart to save affirmations!'))
                  : ListView(
                      controller: scroll,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: _favorites.map((i) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.favorite, color: AppColors.primary, size: 16),
                                const SizedBox(width: 10),
                                Expanded(child: Text(_affirmations[i], style: const TextStyle(fontSize: 13))),
                              ],
                            ),
                          )).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color ?? AppColors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12, color: color ?? AppColors.primary)),
        ],
      ),
    );
  }
}
