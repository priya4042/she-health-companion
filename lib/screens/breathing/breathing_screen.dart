import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isRunning = false;
  int _phase = 0; // 0: breathe in, 1: hold, 2: breathe out, 3: hold
  int _cycle = 0;
  int _selectedTechnique = 0;
  Timer? _phaseTimer;

  static const _techniques = [
    {
      'name': '4-7-8 Calming',
      'desc': 'Reduces anxiety and helps sleep',
      'phases': [4, 7, 8, 0],
      'color': Color(0xFF42A5F5),
    },
    {
      'name': 'Box Breathing',
      'desc': 'Used by Navy SEALs to stay calm',
      'phases': [4, 4, 4, 4],
      'color': Color(0xFF66BB6A),
    },
    {
      'name': 'Energizing',
      'desc': 'Boosts energy and focus',
      'phases': [3, 0, 3, 0],
      'color': Color(0xFFFF9800),
    },
    {
      'name': 'Period Pain Relief',
      'desc': 'Eases cramps and discomfort',
      'phases': [5, 2, 7, 0],
      'color': Color(0xFFE91E63),
    },
  ];

  static const _phaseLabels = ['Breathe In', 'Hold', 'Breathe Out', 'Hold'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    HapticUtils.mediumTap();
    setState(() {
      _isRunning = true;
      _phase = 0;
      _cycle = 0;
    });
    _runPhase();
  }

  void _stop() {
    HapticUtils.mediumTap();
    _phaseTimer?.cancel();
    _controller.stop();
    setState(() => _isRunning = false);
  }

  void _runPhase() {
    if (!_isRunning) return;

    final technique = _techniques[_selectedTechnique];
    final phases = technique['phases'] as List<int>;
    final duration = phases[_phase];

    if (duration == 0) {
      _nextPhase();
      return;
    }

    _controller.duration = Duration(seconds: duration);
    if (_phase == 0) {
      _controller.forward(from: 0);
    } else if (_phase == 2) {
      _controller.reverse(from: 1);
    }

    _phaseTimer = Timer(Duration(seconds: duration), _nextPhase);
  }

  void _nextPhase() {
    if (!_isRunning || !mounted) return;
    HapticUtils.lightTap();
    setState(() {
      _phase = (_phase + 1) % 4;
      if (_phase == 0) _cycle++;
    });
    _runPhase();
  }

  @override
  Widget build(BuildContext context) {
    final technique = _techniques[_selectedTechnique];
    final color = technique['color'] as Color;

    return Scaffold(
      appBar: AppBar(title: const Text('Breathing Exercise')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Technique selector
            if (!_isRunning) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Choose Technique', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              ..._techniques.asMap().entries.map((entry) {
                final i = entry.key;
                final t = entry.value;
                final selected = _selectedTechnique == i;
                final tColor = t['color'] as Color;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticUtils.selection();
                      setState(() => _selectedTechnique = i);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected ? tColor.withValues(alpha: 0.15) : Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? tColor : Colors.grey.withValues(alpha: 0.2),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(color: tColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t['name'] as String,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: tColor)),
                                Text(t['desc'] as String,
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                              ],
                            ),
                          ),
                          if (selected) Icon(Icons.check_circle, color: tColor),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            // Breathing animation
            SizedBox(
              height: 280,
              child: Center(
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer ring
                        Container(
                          width: 240, height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
                          ),
                        ),
                        // Animated circle
                        Transform.scale(
                          scale: _isRunning ? _scaleAnimation.value : 0.8,
                          child: Container(
                            width: 200, height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  color.withValues(alpha: 0.6),
                                  color.withValues(alpha: 0.2),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 40,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _isRunning ? _phaseLabels[_phase] : 'Ready',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_isRunning && _cycle > 0)
                                    Text(
                                      'Cycle $_cycle',
                                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Start/Stop button
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: _isRunning ? _stop : _start,
                icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
                label: Text(_isRunning ? 'Stop' : 'Start',
                    style: const TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (!_isRunning)
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.tips_and_updates, color: AppColors.moodColor, size: 24),
                    const SizedBox(height: 8),
                    const Text('Benefits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text(
                      'Reduces stress • Lowers blood pressure\nImproves focus • Eases anxiety',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }
}
