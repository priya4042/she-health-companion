import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../data/providers/medicine_provider.dart';
import '../../data/providers/mood_provider.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/profile_provider.dart';
import '../../data/providers/sleep_provider.dart';
import '../../data/providers/water_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class ExportReportScreen extends StatelessWidget {
  const ExportReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
              ),
              child: const Column(
                children: [
                  Icon(Icons.description_rounded, color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'Export Health Report',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Generate a PDF summary of your health data\nto share with your doctor',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 24),

            // What's included
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Report Includes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildIncludeItem(Icons.person, 'Personal Information'),
                  _buildIncludeItem(Icons.favorite, 'Period Cycle History'),
                  _buildIncludeItem(Icons.medication, 'Medicine Schedule & Adherence'),
                  _buildIncludeItem(Icons.water_drop, 'Water Intake Summary'),
                  _buildIncludeItem(Icons.bedtime, 'Sleep Pattern Analysis'),
                  _buildIncludeItem(Icons.emoji_emotions, 'Mood Tracking Summary'),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            const SizedBox(height: 24),

            // Generate button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _generateAndPreview(context),
                icon: const Icon(Icons.picture_as_pdf, size: 24),
                label: const Text('Generate PDF Report', style: TextStyle(fontSize: 17)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 12),

            // Share button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => _shareReport(context),
                icon: const Icon(Icons.share, size: 24),
                label: const Text('Share / Print Report', style: TextStyle(fontSize: 17)),
              ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildIncludeItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          const Icon(Icons.check_circle, size: 18, color: AppColors.success),
        ],
      ),
    );
  }

  Future<void> _generateAndPreview(BuildContext context) async {
    final pdf = await _buildPdf(context);

    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Report Preview')),
          body: PdfPreview(
            build: (_) => pdf,
            canChangePageFormat: false,
            canChangeOrientation: false,
          ),
        ),
      ),
    );
  }

  Future<void> _shareReport(BuildContext context) async {
    final pdf = await _buildPdf(context);
    await Printing.sharePdf(bytes: pdf, filename: 'health_report.pdf');
  }

  Future<Uint8List> _buildPdf(BuildContext context) async {
    final profile = context.read<ProfileProvider>();
    final period = context.read<PeriodProvider>();
    final medicine = context.read<MedicineProvider>();
    final water = context.read<WaterProvider>();
    final sleep = context.read<SleepProvider>();
    final mood = context.read<MoodProvider>();

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Daily Life Helper',
                    style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.Text('Health Report',
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.grey600)),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 8),
          ],
        ),
        footer: (ctx) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Generated: ${AppDateUtils.formatDate(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500)),
            pw.Text('Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500)),
          ],
        ),
        build: (ctx) => [
          // Personal info
          _pdfSection('Personal Information', [
            _pdfRow('Name', profile.name.isNotEmpty ? profile.name : 'Not set'),
            _pdfRow('Age', profile.age > 0 ? '${profile.age} years' : 'Not set'),
            _pdfRow('Report Date', AppDateUtils.formatDate(DateTime.now())),
          ]),

          pw.SizedBox(height: 16),

          // Period tracking
          _pdfSection('Period Tracking', [
            _pdfRow('Cycle Length', '${period.cycleLength} days'),
            _pdfRow('Average Cycle', '${period.averageCycleLength.toStringAsFixed(1)} days'),
            _pdfRow('Total Records', '${period.records.length}'),
            if (period.nextPeriodDate != null)
              _pdfRow('Next Predicted', AppDateUtils.formatDate(period.nextPeriodDate!)),
            if (period.latestRecord != null)
              _pdfRow('Last Period', AppDateUtils.formatDate(period.latestRecord!.startDate)),
          ]),

          pw.SizedBox(height: 16),

          // Medicine
          _pdfSection('Medicine Management', [
            _pdfRow('Active Medicines', '${medicine.activeMedicines.length}'),
            _pdfRow("Today's Adherence",
                '${(medicine.todayCompletionRate * 100).round()}%'),
            ...medicine.activeMedicines.map(
              (m) => _pdfRow(
                '  ${m.name}',
                '${m.dosage ?? ""} at ${m.times.join(", ")}',
              ),
            ),
          ]),

          pw.SizedBox(height: 16),

          // Water
          _pdfSection('Water Intake', [
            _pdfRow('Daily Goal', '${water.dailyGoal} glasses (${water.goalMl} ml)'),
            _pdfRow("Today's Intake", '${water.todayGlasses} glasses (${water.todayMl} ml)'),
            _pdfRow('Goal Progress', '${(water.todayProgress * 100).round()}%'),
          ]),

          pw.SizedBox(height: 16),

          // Sleep
          _pdfSection('Sleep Patterns', [
            _pdfRow('Average Duration', '${sleep.averageDuration.toStringAsFixed(1)} hours'),
            _pdfRow('Average Quality', '${sleep.averageQuality.toStringAsFixed(1)} / 5'),
            _pdfRow('Total Records', '${sleep.records.length}'),
            if (sleep.lastNight != null)
              _pdfRow('Last Night', sleep.lastNight!.durationFormatted),
          ]),

          pw.SizedBox(height: 16),

          // Mood
          _pdfSection('Mood Summary', [
            _pdfRow('Average Mood', '${mood.averageMoodScore.toStringAsFixed(1)} / 5'),
            _pdfRow('Journal Streak', '${mood.moodStreak} days'),
            _pdfRow('Total Entries', '${mood.entries.length}'),
          ]),

          pw.SizedBox(height: 24),

          // Disclaimer
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              'Disclaimer: This report is generated from self-reported data and is for informational purposes only. '
              'It should not be used as a substitute for professional medical advice, diagnosis, or treatment.',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );

    return Uint8List.fromList(await doc.save());
  }

  pw.Widget _pdfSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        ...children,
      ],
    );
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
