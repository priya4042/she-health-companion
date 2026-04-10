import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class TimeCapsuleScreen extends StatefulWidget {
  const TimeCapsuleScreen({super.key});

  @override
  State<TimeCapsuleScreen> createState() => _TimeCapsuleScreenState();
}

class _TimeCapsuleScreenState extends State<TimeCapsuleScreen> {
  final _settingsBox = Hive.box(AppConstants.settingsBox);
  List<Map<String, dynamic>> _capsules = [];

  @override
  void initState() {
    super.initState();
    _loadCapsules();
  }

  void _loadCapsules() {
    final raw = _settingsBox.get('time_capsules', defaultValue: <dynamic>[]) as List;
    _capsules = raw.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return {
        'id': m['id'] as String,
        'title': m['title'] as String,
        'message': m['message'] as String,
        'createdAt': DateTime.parse(m['createdAt'] as String),
        'opensAt': DateTime.parse(m['opensAt'] as String),
        'opened': m['opened'] as bool? ?? false,
      };
    }).toList()
      ..sort((a, b) => (a['opensAt'] as DateTime).compareTo(b['opensAt'] as DateTime));
  }

  Future<void> _saveCapsules() async {
    await _settingsBox.put(
        'time_capsules',
        _capsules
            .map((c) => {
                  'id': c['id'],
                  'title': c['title'],
                  'message': c['message'],
                  'createdAt': (c['createdAt'] as DateTime).toIso8601String(),
                  'opensAt': (c['opensAt'] as DateTime).toIso8601String(),
                  'opened': c['opened'],
                })
            .toList());
  }

  void _showCreateDialog() {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String selectedDuration = '1 month';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Letter to Future Self',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Write a message that will be locked away',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: messageController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Your message...',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Open in:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['1 week', '1 month', '3 months', '6 months', '1 year'].map((d) {
                    final selected = selectedDuration == d;
                    return ChoiceChip(
                      label: Text(d),
                      selected: selected,
                      onSelected: (_) {
                        HapticUtils.selection();
                        setSheetState(() => selectedDuration = d);
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (titleController.text.trim().isEmpty || messageController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Please fill in both fields')),
                        );
                        return;
                      }

                      final now = DateTime.now();
                      DateTime opensAt;
                      switch (selectedDuration) {
                        case '1 week':
                          opensAt = now.add(const Duration(days: 7));
                          break;
                        case '1 month':
                          opensAt = DateTime(now.year, now.month + 1, now.day);
                          break;
                        case '3 months':
                          opensAt = DateTime(now.year, now.month + 3, now.day);
                          break;
                        case '6 months':
                          opensAt = DateTime(now.year, now.month + 6, now.day);
                          break;
                        case '1 year':
                          opensAt = DateTime(now.year + 1, now.month, now.day);
                          break;
                        default:
                          opensAt = now.add(const Duration(days: 30));
                      }

                      _capsules.add({
                        'id': now.millisecondsSinceEpoch.toString(),
                        'title': titleController.text.trim(),
                        'message': messageController.text.trim(),
                        'createdAt': now,
                        'opensAt': opensAt,
                        'opened': false,
                      });
                      _saveCapsules();
                      if (mounted) setState(() {});
                      Navigator.pop(ctx);
                      HapticUtils.success();
                    },
                    icon: const Icon(Icons.lock),
                    label: const Text('Seal Time Capsule'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openCapsule(Map<String, dynamic> capsule) async {
    HapticUtils.success();
    capsule['opened'] = true;
    await _saveCapsules();
    if (!mounted) return;
    setState(() {});

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFF6B35)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📜', style: TextStyle(fontSize: 60))
                  .animate().scale(curve: Curves.elasticOut, duration: 800.ms),
              const SizedBox(height: 16),
              Text(capsule['title'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'Sealed ${AppDateUtils.formatDate(capsule['createdAt'] as DateTime)}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  capsule['message'] as String,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF6B35),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Time Capsule')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Letter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF8E24AA), Color(0xFF311B92)],
              ),
              child: const Row(
                children: [
                  Text('💌', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Time Capsule',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Write letters to your future self',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),

            if (_capsules.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text('📭', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 16),
                    Text('No letters yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to write your first letter\nto your future self',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              )
            else
              ..._capsules.map((capsule) {
                final opensAt = capsule['opensAt'] as DateTime;
                final isReady = now.isAfter(opensAt);
                final isOpened = capsule['opened'] as bool;
                final daysLeft = opensAt.difference(now).inDays;

                return _buildCapsuleCard(capsule, isReady, isOpened, daysLeft);
              }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCapsuleCard(Map<String, dynamic> capsule, bool isReady, bool isOpened, int daysLeft) {
    Color color;
    String status;
    IconData icon;

    if (isOpened) {
      color = AppColors.success;
      status = 'Read';
      icon = Icons.mark_email_read;
    } else if (isReady) {
      color = AppColors.primary;
      status = 'Ready to open!';
      icon = Icons.markunread;
    } else {
      color = const Color(0xFF8E24AA);
      status = 'Opens in $daysLeft days';
      icon = Icons.lock;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        onTap: isReady ? () => _openCapsule(capsule) : null,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(capsule['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(status,
                        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sealed ${AppDateUtils.formatDate(capsule['createdAt'] as DateTime)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            if (isReady && !isOpened)
              const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
