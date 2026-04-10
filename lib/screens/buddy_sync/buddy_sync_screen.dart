import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/profile_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class BuddySyncScreen extends StatelessWidget {
  const BuddySyncScreen({super.key});

  String _generateShareCode(BuildContext context) {
    final period = context.read<PeriodProvider>();
    final profile = context.read<ProfileProvider>();

    if (period.latestRecord == null) return '';

    final lastPeriod = period.latestRecord!.startDate;
    final cycleLength = period.cycleLength;
    final name = profile.name.isNotEmpty ? profile.name : 'Friend';

    return '$name|${lastPeriod.toIso8601String().split('T')[0]}|$cycleLength';
  }

  Future<void> _shareWithBuddy(BuildContext context) async {
    HapticUtils.lightTap();
    final period = context.read<PeriodProvider>();
    final profile = context.read<ProfileProvider>();

    if (period.nextPeriodDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log a period first to share with your buddy!')),
      );
      return;
    }

    final daysUntil = period.daysUntilNextPeriod ?? 0;
    final name = profile.name.isNotEmpty ? profile.name : 'Friend';

    final message = '''💕 Period Buddy Update from $name 💕

📅 Next period in: $daysUntil days
🗓️ Expected date: ${AppDateUtils.formatDate(period.nextPeriodDate!)}
⏰ Cycle length: ${period.cycleLength} days
${period.isOnPeriod ? "🩸 Currently on period - Day ${period.currentCycleDay}" : ""}

Stay in sync with me using Daily Life Helper app! 💖''';

    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyCode(BuildContext context) {
    HapticUtils.lightTap();
    final code = _generateShareCode(context);
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log a period first!')),
      );
      return;
    }
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sync code copied!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final period = context.watch<PeriodProvider>();
    final profile = context.watch<ProfileProvider>();
    final shareCode = _generateShareCode(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Period Buddy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFC850C0)],
              ),
              child: const Row(
                children: [
                  Text('👯‍♀️', style: TextStyle(fontSize: 36)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Period Buddy Sync',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Share your cycle with your bestie',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),

            // Your status
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Your Status', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    profile.name.isNotEmpty ? profile.name : 'Set your name',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (period.isOnPeriod)
                    _statusChip('🩸 Day ${period.currentCycleDay}', AppColors.periodColor)
                  else if (period.daysUntilNextPeriod != null)
                    _statusChip('⏰ ${period.daysUntilNextPeriod} days until period', AppColors.primary)
                  else
                    _statusChip('📝 Log your period first', Colors.grey),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 16),

            // Sync code box
            if (shareCode.isNotEmpty)
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_2, size: 80, color: AppColors.primary),
                    const SizedBox(height: 12),
                    const Text('Your Sync Code',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        shareCode,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _copyCode(context),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy Code'),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareWithBuddy(context),
                icon: const Icon(Icons.share),
                label: const Text('Share with Buddy on WhatsApp', style: TextStyle(fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 16),

            // How it works
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info, size: 18),
                      SizedBox(width: 6),
                      Text('How It Works',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...[
                    '1. Share your cycle status with your bestie',
                    '2. They get notified when you\'re on your period',
                    '3. Stay in sync, support each other!',
                    '4. No account or signup required - 100% private',
                  ].map((tip) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(tip,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5)),
                      )),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}
