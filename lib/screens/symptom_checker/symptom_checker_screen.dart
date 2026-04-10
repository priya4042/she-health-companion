import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final Set<String> _selected = {};
  Map<String, dynamic>? _result;

  static const _symptoms = [
    'Severe abdominal pain', 'Mild cramps', 'Heavy bleeding', 'Light spotting',
    'Headache', 'Migraine', 'Bloating', 'Mood swings',
    'Fatigue', 'Acne', 'Hair loss', 'Weight gain',
    'Irregular periods', 'Missed period', 'Breast tenderness', 'Back pain',
    'Nausea', 'Dizziness', 'Hot flashes', 'Insomnia',
  ];

  void _analyze() {
    HapticUtils.mediumTap();
    if (_selected.isEmpty) return;

    String condition = '';
    String severity = '';
    Color color = AppColors.success;
    String advice = '';
    List<String> remedies = [];
    bool seeDoctor = false;

    final hasSevere = _selected.contains('Severe abdominal pain') ||
        _selected.contains('Heavy bleeding') ||
        _selected.contains('Migraine');
    final hasPCOSSigns = _selected.contains('Irregular periods') &&
        (_selected.contains('Acne') || _selected.contains('Hair loss') || _selected.contains('Weight gain'));
    final hasPMS = _selected.contains('Mood swings') &&
        (_selected.contains('Bloating') || _selected.contains('Breast tenderness'));
    final hasMissed = _selected.contains('Missed period');

    if (hasSevere) {
      condition = 'Severe Symptoms Detected';
      severity = 'High';
      color = AppColors.error;
      seeDoctor = true;
      advice = 'Your symptoms suggest a more serious condition. Please consult a doctor as soon as possible.';
      remedies = [
        'Rest in a quiet, dark room',
        'Apply heat to abdomen or back',
        'Stay hydrated',
        'Track symptoms and timing',
      ];
    } else if (hasPCOSSigns) {
      condition = 'Possible PCOS/PCOD';
      severity = 'Moderate';
      color = AppColors.warning;
      seeDoctor = true;
      advice = 'Your symptoms may indicate PCOS. We recommend seeing a gynecologist for blood tests and ultrasound.';
      remedies = [
        'Reduce sugar and refined carbs',
        'Exercise 30 mins daily',
        'Drink spearmint tea',
        'Maintain healthy weight',
        'Manage stress through yoga',
      ];
    } else if (hasMissed) {
      condition = 'Missed Period';
      severity = 'Moderate';
      color = AppColors.warning;
      advice = 'A missed period can have many causes - stress, weight changes, hormonal imbalance, or pregnancy. Take a pregnancy test if applicable.';
      remedies = [
        'Take a pregnancy test',
        'Reduce stress levels',
        'Maintain regular sleep schedule',
        'Eat balanced nutrition',
        'See doctor if missed for 3+ months',
      ];
    } else if (hasPMS) {
      condition = 'PMS (Premenstrual Syndrome)';
      severity = 'Mild to Moderate';
      color = AppColors.waterColor;
      advice = 'Your symptoms are typical of PMS. They should improve once your period starts.';
      remedies = [
        'Drink chamomile or ginger tea',
        'Reduce caffeine and salt',
        'Take vitamin B6 supplements',
        'Light exercise like walking',
        'Get 7-8 hours of sleep',
      ];
    } else {
      condition = 'Mild Symptoms';
      severity = 'Low';
      color = AppColors.success;
      advice = 'Your symptoms are common and manageable with home care.';
      remedies = [
        'Stay hydrated',
        'Use heating pad for cramps',
        'Try gentle yoga',
        'Eat warm, nourishing foods',
        'Get adequate rest',
      ];
    }

    setState(() {
      _result = {
        'condition': condition,
        'severity': severity,
        'color': color,
        'advice': advice,
        'remedies': remedies,
        'seeDoctor': seeDoctor,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Checker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF7E57C2), Color(0xFF512DA8)],
              ),
              child: const Row(
                children: [
                  Icon(Icons.health_and_safety, color: Colors.white, size: 36),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Smart Symptom Checker',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Select your symptoms below',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),

            const Text('Select Your Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptoms.map((s) {
                final selected = _selected.contains(s);
                return FilterChip(
                  label: Text(s, style: TextStyle(fontSize: 12, color: selected ? Colors.white : null)),
                  selected: selected,
                  onSelected: (v) {
                    HapticUtils.selection();
                    setState(() {
                      if (v) {
                        _selected.add(s);
                      } else {
                        _selected.remove(s);
                      }
                    });
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: Theme.of(context).cardTheme.color,
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selected.isEmpty ? null : _analyze,
                icon: const Icon(Icons.analytics),
                label: const Text('Analyze Symptoms'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(height: 20),

            if (_result != null) _buildResult(),
            const SizedBox(height: 20),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is not medical advice. Always consult a qualified doctor for diagnosis and treatment.',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final r = _result!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientCard(
          gradient: LinearGradient(colors: [r['color'] as Color, (r['color'] as Color).withValues(alpha: 0.7)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.medical_services, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(r['condition'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Severity: ${r['severity']}',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              Text(r['advice'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Recommended Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ...(r['remedies'] as List<String>).map((rem) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, size: 16, color: r['color'] as Color),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rem, style: const TextStyle(fontSize: 13, height: 1.4))),
                      ],
                    ),
                  )),
              if (r['seeDoctor'] as bool) ...[
                const Divider(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.local_hospital, color: AppColors.error, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Please consult a doctor',
                            style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }
}
