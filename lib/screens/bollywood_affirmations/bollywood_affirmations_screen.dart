import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/gradient_card.dart';

class BollywoodAffirmationsScreen extends StatefulWidget {
  const BollywoodAffirmationsScreen({super.key});

  @override
  State<BollywoodAffirmationsScreen> createState() => _BollywoodAffirmationsScreenState();
}

class _BollywoodAffirmationsScreenState extends State<BollywoodAffirmationsScreen> {
  int _currentIndex = 0;

  static const _affirmations = [
    {
      'quote': 'Kuch kuch hota hai, tum nahi samjhogi... that I am amazing!',
      'translation': 'Believe in your magic',
      'movie': 'Inspired by KKHH',
    },
    {
      'quote': 'Don\'t underestimate the power of a common woman.',
      'translation': 'You are powerful',
      'movie': 'Chennai Express vibes',
    },
    {
      'quote': 'Ek ladki ko dekha toh aisa laga... she\'s glowing!',
      'translation': 'You shine bright',
      'movie': '1942 A Love Story',
    },
    {
      'quote': 'Pyaar dosti hai. Self-love bhi dosti hai.',
      'translation': 'Be your own best friend',
      'movie': 'KKHH',
    },
    {
      'quote': 'Big B says: Kaun banega health champion? You will!',
      'translation': 'You are the champion',
      'movie': 'KBC inspired',
    },
    {
      'quote': 'Bade bade deshon mein, aisi choti choti baatein hoti rehti hain.',
      'translation': 'Don\'t sweat the small stuff',
      'movie': 'DDLJ',
    },
    {
      'quote': 'Picture abhi baaki hai mere dost! Your story is just beginning.',
      'translation': 'Your best is yet to come',
      'movie': 'Om Shanti Om',
    },
    {
      'quote': 'Mere paas health hai! That\'s the real wealth.',
      'translation': 'Health is wealth',
      'movie': 'Deewar inspired',
    },
    {
      'quote': 'All izz well. Repeat it. All izz well!',
      'translation': 'Trust the process',
      'movie': '3 Idiots',
    },
    {
      'quote': 'Senorita, big things have small beginnings. Keep going!',
      'translation': 'Small steps matter',
      'movie': 'ZNMD',
    },
    {
      'quote': 'Apne sapno ko marne mat dena. Don\'t let your dreams die.',
      'translation': 'Chase your dreams',
      'movie': 'Wake Up Sid',
    },
    {
      'quote': 'Tum apni body se pyaar karo, body tumse pyaar karegi.',
      'translation': 'Love your body, it loves you back',
      'movie': 'Original wisdom',
    },
    {
      'quote': 'Mogambo khush hua! Make yourself happy first.',
      'translation': 'Your happiness matters',
      'movie': 'Mr. India',
    },
    {
      'quote': 'Don\'t angry me, but listen — you are enough, exactly as you are.',
      'translation': 'You are enough',
      'movie': 'Rowdy Rathore vibes',
    },
    {
      'quote': 'Zindagi na milegi dobara! Live every day fully.',
      'translation': 'You only live once',
      'movie': 'ZNMD',
    },
    {
      'quote': 'Hum hain rahi pyaar ke... self-love ke!',
      'translation': 'On a journey of self-love',
      'movie': 'Hum Hain Rahi Pyaar Ke',
    },
    {
      'quote': 'Tareekh pe tareekh, period pe period — track them all!',
      'translation': 'Track everything',
      'movie': 'Damini',
    },
    {
      'quote': 'Bas itna sa khwab hai... to be healthy and happy!',
      'translation': 'Simple dreams matter',
      'movie': 'Yes Boss',
    },
  ];

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
    final affirmation = _affirmations[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Bollywood Affirmations')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFE91E63)],
              ),
              child: const Row(
                children: [
                  Text('🎬', style: TextStyle(fontSize: 36)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bollywood Vibes',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Affirmations with desi swag',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 30),

            // Main quote card
            GradientCard(
              key: ValueKey(_currentIndex),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFF6B35), Color(0xFFE91E63)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const Icon(Icons.format_quote, color: Colors.white70, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    affirmation['quote']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    affirmation['translation']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '🎥 ${affirmation['movie']}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ).animate(key: ValueKey(_currentIndex)).fadeIn().scale(begin: const Offset(0.9, 0.9)),
            const SizedBox(height: 24),

            // Counter
            Text(
              '${_currentIndex + 1} of ${_affirmations.length}',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _previous,
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFE91E63)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.movie_filter, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text('Bollywood Style',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _next,
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
