import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/haptic_utils.dart';
import '../../data/providers/medicine_provider.dart';
import '../../data/providers/mood_provider.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/water_provider.dart';

class YearReviewScreen extends StatefulWidget {
  const YearReviewScreen({super.key});

  @override
  State<YearReviewScreen> createState() => _YearReviewScreenState();
}

class _YearReviewScreenState extends State<YearReviewScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();
    final period = context.watch<PeriodProvider>();
    final medicine = context.watch<MedicineProvider>();
    final mood = context.watch<MoodProvider>();
    final year = DateTime.now().year;

    final pages = [
      _buildIntroPage(year),
      _buildWaterPage(water),
      _buildPeriodPage(period),
      _buildMedicinePage(medicine),
      _buildMoodPage(mood),
      _buildSummaryPage(water, period, medicine, mood),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('$year in Review', style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _share(context, water, period, medicine, mood),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) {
                HapticUtils.lightTap();
                setState(() => _currentPage = i);
              },
              children: pages,
            ),
          ),
          // Page indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentPage ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentPage ? Colors.white : Colors.white30,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(int year) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFFC850C0), Color(0xFF4158D0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✨', style: TextStyle(fontSize: 80))
                  .animate(onPlay: (c) => c.repeat())
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 1500.ms)
                  .then()
                  .scale(begin: const Offset(1.1, 1.1), end: const Offset(0.9, 0.9), duration: 1500.ms),
              const SizedBox(height: 20),
              const Text(
                'Your Year',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w300),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
              Text(
                '$year',
                style: const TextStyle(color: Colors.white, fontSize: 96, fontWeight: FontWeight.bold, letterSpacing: -2),
              ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.5, 0.5)),
              const SizedBox(height: 16),
              const Text(
                'A health journey worth celebrating',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 40),
              const Icon(Icons.swipe_rounded, color: Colors.white70, size: 32)
                  .animate(onPlay: (c) => c.repeat())
                  .moveX(begin: -10, end: 10, duration: 1500.ms)
                  .then()
                  .moveX(begin: 10, end: -10, duration: 1500.ms),
              const Text('Swipe to see more', style: TextStyle(color: Colors.white60, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaterPage(WaterProvider water) {
    final totalGlasses = water.allIntakes.fold<int>(0, (sum, i) => sum + i.glasses);
    final totalLiters = (totalGlasses * 0.25).toStringAsFixed(1);

    return _statPage(
      gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1565C0)]),
      emoji: '💧',
      bigNumber: '$totalGlasses',
      label: 'glasses of water',
      subtitle: 'That\'s $totalLiters liters!',
      fact: 'You hydrated yourself ${(totalGlasses / 8).round()} days worth',
    );
  }

  Widget _buildPeriodPage(PeriodProvider period) {
    return _statPage(
      gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFAD1457)]),
      emoji: '🩸',
      bigNumber: '${period.records.length}',
      label: 'periods tracked',
      subtitle: 'Average cycle: ${period.averageCycleLength.toStringAsFixed(0)} days',
      fact: 'You\'ve gotten to know your body so well',
    );
  }

  Widget _buildMedicinePage(MedicineProvider medicine) {
    return _statPage(
      gradient: const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)]),
      emoji: '💊',
      bigNumber: '${medicine.activeMedicines.length}',
      label: 'medicines tracked',
      subtitle: '${(medicine.todayCompletionRate * 100).round()}% adherence today',
      fact: 'Consistency is the key to healing',
    );
  }

  Widget _buildMoodPage(MoodProvider mood) {
    return _statPage(
      gradient: const LinearGradient(colors: [Color(0xFFFFB74D), Color(0xFFEF6C00)]),
      emoji: '😊',
      bigNumber: '${mood.entries.length}',
      label: 'mood entries',
      subtitle: 'Average mood: ${mood.averageMoodScore.toStringAsFixed(1)}/5',
      fact: 'You honored your feelings ${mood.entries.length} times',
    );
  }

  Widget _buildSummaryPage(WaterProvider water, PeriodProvider period,
      MedicineProvider medicine, MoodProvider mood) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 80))
                  .animate().scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 800.ms),
              const SizedBox(height: 20),
              const Text(
                'You\'re Amazing!',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              const Text(
                'Your year of self-care',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _summaryRow('💧 Glasses of water',
                        '${water.allIntakes.fold<int>(0, (s, i) => s + i.glasses)}'),
                    _summaryRow('🩸 Periods tracked', '${period.records.length}'),
                    _summaryRow('💊 Medicines', '${medicine.activeMedicines.length}'),
                    _summaryRow('😊 Mood entries', '${mood.entries.length}'),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _share(context, water, period, medicine, mood),
                icon: const Icon(Icons.share),
                label: const Text('Share Your Year'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statPage({
    required LinearGradient gradient,
    required String emoji,
    required String bigNumber,
    required String label,
    required String subtitle,
    required String fact,
  }) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 80))
                    .animate().scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 600.ms),
                const SizedBox(height: 24),
                Text(
                  bigNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -3,
                    height: 1,
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.7, 0.7)),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ).animate().fadeIn(delay: 700.ms),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    fact,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _share(BuildContext context, WaterProvider water, PeriodProvider period,
      MedicineProvider medicine, MoodProvider mood) async {
    HapticUtils.lightTap();
    final year = DateTime.now().year;
    final glasses = water.allIntakes.fold<int>(0, (s, i) => s + i.glasses);
    final message = '''🌟 My $year Health Recap 🌟

💧 ${glasses} glasses of water
🩸 ${period.records.length} periods tracked
💊 ${medicine.activeMedicines.length} medicines managed
😊 ${mood.entries.length} mood entries

Tracked with Daily Life Helper - your complete health companion!
#HealthGoals #SelfCare''';

    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Clipboard.setData(ClipboardData(text: message));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard!')),
        );
      }
    }
  }
}
