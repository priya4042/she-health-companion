import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/medicine_provider.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/profile_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class AskDoctorScreen extends StatefulWidget {
  const AskDoctorScreen({super.key});

  @override
  State<AskDoctorScreen> createState() => _AskDoctorScreenState();
}

class _AskDoctorScreenState extends State<AskDoctorScreen> {
  final Set<int> _selectedQuestions = {};
  final _customController = TextEditingController();

  static const _commonQuestions = [
    'My periods are irregular, what could be the cause?',
    'I have severe pain during periods, is it normal?',
    'My periods are heavy, should I be worried?',
    'I missed my period, what tests should I take?',
    'I have hair growth on face, is it PCOS?',
    'I have acne and weight gain, could it be hormonal?',
    'I have white discharge, is it normal?',
    'My breasts are tender, what could it mean?',
    'I have lower back pain during periods, why?',
    'Should I get an ultrasound or blood tests?',
    'Are my symptoms PCOS or PCOD?',
    'What lifestyle changes do you recommend?',
    'Are the medicines I\'m taking causing side effects?',
    'Should I take any supplements (iron, calcium)?',
    'When should I come for follow-up?',
  ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String _generateNotes(BuildContext context) {
    final profile = context.read<ProfileProvider>();
    final period = context.read<PeriodProvider>();
    final medicine = context.read<MedicineProvider>();

    final buffer = StringBuffer();
    buffer.writeln('=== DOCTOR VISIT NOTES ===');
    buffer.writeln('Date: ${AppDateUtils.formatDate(DateTime.now())}');
    buffer.writeln('');
    buffer.writeln('Patient: ${profile.name.isNotEmpty ? profile.name : "Not set"}');
    if (profile.age > 0) buffer.writeln('Age: ${profile.age}');
    buffer.writeln('');

    buffer.writeln('--- CYCLE INFO ---');
    buffer.writeln('Cycle Length: ${period.cycleLength} days');
    buffer.writeln('Period Duration: ${period.periodDuration} days');
    buffer.writeln('Average Cycle: ${period.averageCycleLength.toStringAsFixed(1)} days');
    if (period.latestRecord != null) {
      buffer.writeln('Last Period: ${AppDateUtils.formatDate(period.latestRecord!.startDate)}');
    }
    if (period.nextPeriodDate != null) {
      buffer.writeln('Next Predicted: ${AppDateUtils.formatDate(period.nextPeriodDate!)}');
    }
    buffer.writeln('Total Records: ${period.records.length}');
    buffer.writeln('');

    if (medicine.activeMedicines.isNotEmpty) {
      buffer.writeln('--- CURRENT MEDICATIONS ---');
      for (final m in medicine.activeMedicines) {
        buffer.writeln('• ${m.name}${m.dosage != null ? " (${m.dosage})" : ""} - ${m.times.join(", ")}');
      }
      buffer.writeln('');
    }

    if (_selectedQuestions.isNotEmpty || _customController.text.trim().isNotEmpty) {
      buffer.writeln('--- QUESTIONS FOR DOCTOR ---');
      int n = 1;
      for (final i in _selectedQuestions) {
        buffer.writeln('$n. ${_commonQuestions[i]}');
        n++;
      }
      if (_customController.text.trim().isNotEmpty) {
        buffer.writeln('$n. ${_customController.text.trim()}');
      }
    }

    return buffer.toString();
  }

  void _copyToClipboard() {
    final notes = _generateNotes(context);
    Clipboard.setData(ClipboardData(text: notes));
    HapticUtils.success();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard! Paste it in your doctor\'s app or notes.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Visit Prep')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF26A69A), Color(0xFF00695C)],
              ),
              child: const Row(
                children: [
                  Icon(Icons.medical_services_rounded, color: Colors.white, size: 36),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Be Prepared',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Generate notes for your next appointment',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),

            const Text('Common Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ..._commonQuestions.asMap().entries.map((entry) {
              final i = entry.key;
              final q = entry.value;
              final selected = _selectedQuestions.contains(i);
              return GestureDetector(
                onTap: () {
                  HapticUtils.selection();
                  setState(() {
                    if (selected) {
                      _selectedQuestions.remove(i);
                    } else {
                      _selectedQuestions.add(i);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: selected ? AppColors.primary : Colors.grey,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(q,
                            style: TextStyle(
                              fontSize: 13,
                              color: selected ? AppColors.primary : null,
                              fontWeight: selected ? FontWeight.w600 : null,
                            )),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (i * 30).ms);
            }),
            const SizedBox(height: 20),

            const Text('Custom Question', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _customController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add your own question for the doctor...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Generate buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy),
                label: const Text('Copy Doctor Notes', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Preview
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.preview, color: AppColors.primary, size: 18),
                      SizedBox(width: 6),
                      Text('Preview', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _generateNotes(context),
                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace', height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
