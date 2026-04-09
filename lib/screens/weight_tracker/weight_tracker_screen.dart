import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/weight_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class WeightTrackerScreen extends StatefulWidget {
  const WeightTrackerScreen({super.key});

  @override
  State<WeightTrackerScreen> createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
  final _weightController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weight = context.watch<WeightProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Weight & Body Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Current stats
            if (weight.latest != null)
              _buildCurrentStats(weight)
                  .animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
            if (weight.latest != null) const SizedBox(height: 20),

            // Log weight
            _buildLogSection(context, weight)
                .animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),

            // Chart
            if (weight.records.length >= 2)
              _buildChart(weight)
                  .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            if (weight.records.length >= 2) const SizedBox(height: 20),

            // History
            _buildHistory(weight)
                .animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStats(WeightProvider weight) {
    final record = weight.latest!;
    final change = weight.weightChange;

    return GradientCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF26A69A), Color(0xFF00897B)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Weight', style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text(
                  '${record.weight.toStringAsFixed(1)} kg',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      change > 0 ? Icons.trending_up : change < 0 ? Icons.trending_down : Icons.trending_flat,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${change > 0 ? "+" : ""}${change.toStringAsFixed(1)} kg',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const Text(' since last', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (record.waistToHipRatio != null) ...[
                const Text('W:H Ratio', style: TextStyle(color: Colors.white70, fontSize: 11)),
                Text(
                  record.waistToHipRatio!.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogSection(BuildContext context, WeightProvider weight) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Log Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              prefixIcon: Icon(Icons.monitor_weight),
              hintText: '55.5',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _waistController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Waist (cm)',
                    prefixIcon: Icon(Icons.straighten),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _hipController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Hip (cm)',
                    prefixIcon: Icon(Icons.straighten),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _save(weight),
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bmiColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(WeightProvider weight) {
    final data = weight.monthlyData;
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = data.map((d) =>
        FlSpot((d['day'] as int).toDouble(), d['weight'] as double)).toList();
    final minW = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 2;
    final maxW = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 2;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.show_chart, color: AppColors.bmiColor, size: 20),
              SizedBox(width: 8),
              Text('Weight Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) =>
                          Text('${value.toInt()}', style: const TextStyle(fontSize: 10)),
                      reservedSize: 22,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, _) =>
                          Text('${value.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: minW,
                maxY: maxW,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(colors: [AppColors.bmiColor, Color(0xFF00897B)]),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.bmiColor,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [AppColors.bmiColor.withValues(alpha: 0.3), AppColors.bmiColor.withValues(alpha: 0.0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(WeightProvider weight) {
    final records = weight.records.take(10).toList();
    if (records.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...records.map((r) => GlassCard(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.monitor_weight, color: AppColors.bmiColor),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${r.weight.toStringAsFixed(1)} kg',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(AppDateUtils.formatDate(r.date),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  if (r.waist != null)
                    Text('W: ${r.waist!.toStringAsFixed(0)}cm',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  if (r.hip != null)
                    Text(' H: ${r.hip!.toStringAsFixed(0)}cm',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            )),
      ],
    );
  }

  void _save(WeightProvider weight) {
    final w = double.tryParse(_weightController.text);
    if (w == null || w <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid weight')),
      );
      return;
    }
    HapticUtils.success();
    weight.addRecord(
      weight: w,
      waist: double.tryParse(_waistController.text),
      hip: double.tryParse(_hipController.text),
    );
    _weightController.clear();
    _waistController.clear();
    _hipController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Weight logged!'),
        backgroundColor: AppColors.bmiColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
