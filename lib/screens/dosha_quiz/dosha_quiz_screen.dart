import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class DoshaQuizScreen extends StatefulWidget {
  const DoshaQuizScreen({super.key});

  @override
  State<DoshaQuizScreen> createState() => _DoshaQuizScreenState();
}

class _DoshaQuizScreenState extends State<DoshaQuizScreen> {
  int _currentQuestion = 0;
  final Map<String, int> _scores = {'vata': 0, 'pitta': 0, 'kapha': 0};
  String? _result;

  static const _questions = [
    {
      'q': 'My body frame is...',
      'options': [
        {'text': 'Thin and lean', 'dosha': 'vata'},
        {'text': 'Medium build', 'dosha': 'pitta'},
        {'text': 'Sturdy and broad', 'dosha': 'kapha'},
      ],
    },
    {
      'q': 'My skin is usually...',
      'options': [
        {'text': 'Dry and rough', 'dosha': 'vata'},
        {'text': 'Sensitive and warm', 'dosha': 'pitta'},
        {'text': 'Smooth and oily', 'dosha': 'kapha'},
      ],
    },
    {
      'q': 'My hair is...',
      'options': [
        {'text': 'Dry and frizzy', 'dosha': 'vata'},
        {'text': 'Fine and prone to greying', 'dosha': 'pitta'},
        {'text': 'Thick and lustrous', 'dosha': 'kapha'},
      ],
    },
    {
      'q': 'My appetite is...',
      'options': [
        {'text': 'Variable, sometimes I forget to eat', 'dosha': 'vata'},
        {'text': 'Strong, I get hangry', 'dosha': 'pitta'},
        {'text': 'Steady but I can skip meals', 'dosha': 'kapha'},
      ],
    },
    {
      'q': 'My sleep is...',
      'options': [
        {'text': 'Light, often interrupted', 'dosha': 'vata'},
        {'text': 'Sound but short', 'dosha': 'pitta'},
        {'text': 'Deep and long', 'dosha': 'kapha'},
      ],
    },
    {
      'q': 'When stressed, I become...',
      'options': [
        {'text': 'Anxious and worried', 'dosha': 'vata'},
        {'text': 'Irritable and angry', 'dosha': 'pitta'},
        {'text': 'Withdrawn and lethargic', 'dosha': 'kapha'},
      ],
    },
    {
      'q': 'My energy level is...',
      'options': [
        {'text': 'Bursts of energy', 'dosha': 'vata'},
        {'text': 'Strong and focused', 'dosha': 'pitta'},
        {'text': 'Steady and enduring', 'dosha': 'kapha'},
      ],
    },
    {
      'q': 'My periods are usually...',
      'options': [
        {'text': 'Irregular, light, with cramps', 'dosha': 'vata'},
        {'text': 'Heavy with intense cramps', 'dosha': 'pitta'},
        {'text': 'Regular, moderate flow', 'dosha': 'kapha'},
      ],
    },
  ];

  static const _doshaInfo = {
    'vata': {
      'name': 'Vata',
      'element': 'Air & Space',
      'color': Color(0xFF7E57C2),
      'emoji': '🌬️',
      'desc': 'Creative, energetic, and quick-thinking. You move and act fast.',
      'foods': 'Warm, cooked, oily foods. Sweet, sour, salty tastes. Avoid cold and dry foods.',
      'lifestyle': 'Regular routine, warm baths, oil massage, gentle yoga, early sleep.',
      'avoid': 'Cold weather, irregular meals, excessive caffeine, overstimulation.',
    },
    'pitta': {
      'name': 'Pitta',
      'element': 'Fire & Water',
      'color': Color(0xFFE91E63),
      'emoji': '🔥',
      'desc': 'Sharp, ambitious, and natural leader. Strong digestion and metabolism.',
      'foods': 'Cool, fresh foods. Sweet, bitter, astringent tastes. Avoid spicy and fried foods.',
      'lifestyle': 'Cooling activities, swimming, moonlight walks, meditation, avoid overheating.',
      'avoid': 'Hot climates, spicy food, anger, working in midday sun.',
    },
    'kapha': {
      'name': 'Kapha',
      'element': 'Earth & Water',
      'color': Color(0xFF26A69A),
      'emoji': '🌍',
      'desc': 'Calm, grounded, and nurturing. Strong immunity and stamina.',
      'foods': 'Light, warm, dry foods. Pungent, bitter, astringent tastes. Avoid heavy and sweet foods.',
      'lifestyle': 'Vigorous exercise, early rising, dry brushing, stimulating activities.',
      'avoid': 'Cold and damp weather, daytime sleep, heavy meals, excess dairy.',
    },
  };

  void _selectAnswer(String dosha) {
    HapticUtils.selection();
    _scores[dosha] = (_scores[dosha] ?? 0) + 1;

    if (_currentQuestion < _questions.length - 1) {
      setState(() => _currentQuestion++);
    } else {
      // Calculate result
      final sorted = _scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      setState(() => _result = sorted.first.key);
      HapticUtils.success();
    }
  }

  void _restart() {
    setState(() {
      _currentQuestion = 0;
      _scores.updateAll((_, __) => 0);
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayurveda Dosha Quiz')),
      body: _result != null ? _buildResult() : _buildQuiz(),
    );
  }

  Widget _buildQuiz() {
    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Question ${_currentQuestion + 1} of ${_questions.length}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 30),

          // Question
          GlassCard(
            key: ValueKey(_currentQuestion),
            padding: const EdgeInsets.all(24),
            child: Text(
              question['q'] as String,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ).animate(key: ValueKey(_currentQuestion)).fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 24),

          // Options
          ...((question['options'] as List).asMap().entries.map((entry) {
            final i = entry.key;
            final opt = entry.value as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _selectAnswer(opt['dosha'] as String),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardTheme.color,
                    foregroundColor: AppColors.textPrimaryLight,
                    padding: const EdgeInsets.all(20),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(String.fromCharCode(65 + i),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(opt['text'] as String,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate(delay: (i * 100).ms).fadeIn().slideX(begin: 0.1);
          })),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final dosha = _doshaInfo[_result]!;
    final color = dosha['color'] as Color;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GradientCard(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Text(dosha['emoji'] as String, style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 12),
                Text('You are', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                Text(dosha['name'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                Text(dosha['element'] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 12),
                Text(dosha['desc'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
          const SizedBox(height: 20),

          _infoCard('🍽️ Recommended Foods', dosha['foods'] as String, color)
              .animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 12),
          _infoCard('🧘 Lifestyle Tips', dosha['lifestyle'] as String, color)
              .animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 12),
          _infoCard('⚠️ Things to Avoid', dosha['avoid'] as String, color)
              .animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: _restart,
            icon: const Icon(Icons.refresh),
            label: const Text('Take Quiz Again'),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String content, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}
