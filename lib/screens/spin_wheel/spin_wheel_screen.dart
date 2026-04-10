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

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  bool _isSpinning = false;
  bool _spunToday = false;
  Map<String, dynamic>? _result;
  final _settingsBox = Hive.box(AppConstants.settingsBox);

  static const _prizes = [
    {'label': '+10 pts', 'icon': '⭐', 'color': Color(0xFFFFD700), 'type': 'points', 'value': 10},
    {'label': 'Tip', 'icon': '💡', 'color': Color(0xFF66BB6A), 'type': 'tip', 'value': 0},
    {'label': '+25 pts', 'icon': '💎', 'color': Color(0xFF42A5F5), 'type': 'points', 'value': 25},
    {'label': 'Quote', 'icon': '💬', 'color': Color(0xFFAB47BC), 'type': 'quote', 'value': 0},
    {'label': '+15 pts', 'icon': '🌟', 'color': Color(0xFFFF6B9D), 'type': 'points', 'value': 15},
    {'label': 'Sticker', 'icon': '🎁', 'color': Color(0xFFFF8A65), 'type': 'sticker', 'value': 0},
    {'label': '+50 pts', 'icon': '🏆', 'color': Color(0xFFE91E63), 'type': 'points', 'value': 50},
    {'label': 'Mantra', 'icon': '🕉️', 'color': Color(0xFF26A69A), 'type': 'mantra', 'value': 0},
  ];

  static const _tips = [
    'Drink a glass of water right now!',
    'Take 5 deep breaths and stretch.',
    'Stand up and walk for 2 minutes.',
    'Eat a piece of fruit today.',
    'Do 10 squats right where you are.',
    'Smile at someone today.',
  ];

  static const _quotes = [
    'You are stronger than you know.',
    'Today is a gift, that\'s why it\'s called present.',
    'Self-care is not selfish.',
    'You\'re doing better than you think.',
  ];

  static const _mantras = [
    'Om Shanti — Peace within',
    'Lokah Samastah Sukhino Bhavantu — May all beings be happy',
    'Aham Brahmasmi — I am the universe',
    'So Hum — I am that',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _rotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    final lastSpinStr = _settingsBox.get('last_spin');
    if (lastSpinStr != null) {
      final lastSpin = DateTime.parse(lastSpinStr as String);
      _spunToday = AppDateUtils.isSameDay(lastSpin, DateTime.now());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _spin(GamificationProvider game) async {
    if (_isSpinning || _spunToday) return;

    HapticUtils.heavyTap();
    setState(() {
      _isSpinning = true;
      _result = null;
    });

    final random = Random();
    final winnerIndex = random.nextInt(_prizes.length);
    final spins = 5 + random.nextDouble() * 2; // 5-7 full rotations
    final endRotation = spins + (winnerIndex / _prizes.length);

    _controller.reset();
    _rotation = Tween<double>(begin: 0, end: endRotation).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    await _controller.forward();

    if (!mounted) return;
    final prize = _prizes[winnerIndex];
    final result = Map<String, dynamic>.from(prize);

    // Add bonus content
    if (prize['type'] == 'tip') {
      result['content'] = _tips[random.nextInt(_tips.length)];
    } else if (prize['type'] == 'quote') {
      result['content'] = _quotes[random.nextInt(_quotes.length)];
    } else if (prize['type'] == 'mantra') {
      result['content'] = _mantras[random.nextInt(_mantras.length)];
    } else if (prize['type'] == 'points') {
      await game.addBonusPoints(prize['value'] as int);
    }

    await _settingsBox.put('last_spin', DateTime.now().toIso8601String());

    if (!mounted) return;
    setState(() {
      _isSpinning = false;
      _spunToday = true;
      _result = result;
    });

    HapticUtils.success();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GamificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Spin the Wheel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFF6B35)],
              ),
              child: Row(
                children: [
                  const Text('🎡', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily Spin',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(_spunToday ? 'Come back tomorrow!' : 'Spin once per day for free!',
                            style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 32),

            // Wheel
            SizedBox(
              height: 320,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _rotation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotation.value * 2 * pi,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: CustomPaint(
                        painter: _WheelPainter(prizes: _prizes),
                      ),
                    ),
                  ),
                  // Pointer at top
                  Positioned(
                    top: 0,
                    child: Icon(Icons.arrow_drop_down, size: 60, color: Colors.red.shade700),
                  ),
                  // Center button
                  GestureDetector(
                    onTap: _spunToday || _isSpinning ? null : () => _spin(game),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: _spunToday ? Colors.grey : AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: (_spunToday ? Colors.grey : AppColors.primary).withValues(alpha: 0.5),
                              blurRadius: 12),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _spunToday ? '✓' : 'SPIN',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (_result != null)
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(_result!['icon'] as String, style: const TextStyle(fontSize: 48))
                        .animate().scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 600.ms),
                    const SizedBox(height: 12),
                    Text(
                      'You won: ${_result!['label']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ).animate().fadeIn(delay: 200.ms),
                    if (_result!['content'] != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _result!['content'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Total: ${game.totalPoints} points',
                  style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<Map<String, dynamic>> prizes;

  _WheelPainter({required this.prizes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / prizes.length;

    for (int i = 0; i < prizes.length; i++) {
      final paint = Paint()..color = prizes[i]['color'] as Color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * segmentAngle - pi / 2,
        segmentAngle,
        true,
        paint,
      );

      // Draw text
      final textAngle = i * segmentAngle - pi / 2 + segmentAngle / 2;
      final textRadius = radius * 0.65;
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${prizes[i]['icon']}\n${prizes[i]['label']}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle + pi / 2);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }

    // Border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, borderPaint);

    // Segment dividers
    for (int i = 0; i < prizes.length; i++) {
      final angle = i * segmentAngle - pi / 2;
      final endX = center.dx + radius * cos(angle);
      final endY = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(endX, endY), borderPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
