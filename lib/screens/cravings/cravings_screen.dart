import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class CravingsScreen extends StatefulWidget {
  const CravingsScreen({super.key});

  @override
  State<CravingsScreen> createState() => _CravingsScreenState();
}

class _CravingsScreenState extends State<CravingsScreen> {
  final _settingsBox = Hive.box(AppConstants.settingsBox);
  List<Map<String, dynamic>> _cravings = [];

  static const _cravingTypes = [
    {'emoji': '🍫', 'name': 'Chocolate'},
    {'emoji': '🍦', 'name': 'Ice Cream'},
    {'emoji': '🍕', 'name': 'Pizza'},
    {'emoji': '🍔', 'name': 'Burger'},
    {'emoji': '🍟', 'name': 'Fries'},
    {'emoji': '🥤', 'name': 'Soda'},
    {'emoji': '☕', 'name': 'Coffee'},
    {'emoji': '🍪', 'name': 'Cookies'},
    {'emoji': '🍩', 'name': 'Donuts'},
    {'emoji': '🌶️', 'name': 'Spicy'},
    {'emoji': '🧂', 'name': 'Salty'},
    {'emoji': '🍰', 'name': 'Cake'},
  ];

  @override
  void initState() {
    super.initState();
    _loadFromBox();
  }

  void _loadFromBox() {
    final raw = _settingsBox.get('cravings', defaultValue: <dynamic>[]) as List;
    _cravings = raw.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return {
        'emoji': m['emoji'] as String,
        'name': m['name'] as String,
        'date': DateTime.parse(m['date'] as String),
      };
    }).toList()..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
  }

  Future<void> _addCraving(String emoji, String name) async {
    HapticUtils.lightTap();
    _cravings.insert(0, {'emoji': emoji, 'name': name, 'date': DateTime.now()});
    await _settingsBox.put('cravings', _cravings.map((c) => {
          'emoji': c['emoji'],
          'name': c['name'],
          'date': (c['date'] as DateTime).toIso8601String(),
        }).toList());
    if (mounted) setState(() {});
  }

  Map<String, int> get _topCravings {
    final counts = <String, int>{};
    for (final c in _cravings) {
      final key = '${c['emoji']} ${c['name']}';
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Cravings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A65), Color(0xFFE64A19)],
              ),
              child: Row(
                children: [
                  const Text('🍫', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Track Cravings',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${_cravings.length} logged',
                            style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),

            const Text("What are you craving?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _cravingTypes.map((c) {
                return GestureDetector(
                  onTap: () => _addCraving(c['emoji']!, c['name']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(c['emoji']!, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 6),
                        Text(c['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            if (_topCravings.isNotEmpty) ...[
              const Text('Top Cravings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  children: _topCravings.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Text(e.key.split(' ').first, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(e.key.split(' ').sublist(1).join(' '))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('${e.value}x', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (_cravings.isNotEmpty) ...[
              const Text('Recent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ..._cravings.take(10).map((c) => GlassCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Text(c['emoji'] as String, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(AppDateUtils.formatDate(c['date'] as DateTime),
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
