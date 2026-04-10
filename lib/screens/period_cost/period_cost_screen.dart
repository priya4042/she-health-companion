import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class PeriodCostScreen extends StatefulWidget {
  const PeriodCostScreen({super.key});

  @override
  State<PeriodCostScreen> createState() => _PeriodCostScreenState();
}

class _PeriodCostScreenState extends State<PeriodCostScreen> {
  double _padsPerCycle = 20;
  double _padCost = 8;
  double _painkillerCost = 50;
  double _otherCost = 0;
  int _ageStarted = 13;
  int _currentAge = 25;

  double get _cyclesPerYear => 13;
  double get _yearlyCost {
    final perCycle = (_padsPerCycle * _padCost) + _painkillerCost + _otherCost;
    return perCycle * _cyclesPerYear;
  }
  double get _lifetimeCost => (_yearlyCost * (50 - _ageStarted)).clamp(0, double.infinity);
  double get _spentSoFar => (_yearlyCost * (_currentAge - _ageStarted)).clamp(0, double.infinity);
  double get _remainingCost => (_yearlyCost * (50 - _currentAge)).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Period Cost Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('💰', style: TextStyle(fontSize: 32)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'How much do periods really cost?',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCostRow('Yearly', '₹${_yearlyCost.toStringAsFixed(0)}', Colors.white),
                  _buildCostRow('Lifetime (until 50)', '₹${_lifetimeCost.toStringAsFixed(0)}', Colors.white),
                  _buildCostRow('Spent so far', '₹${_spentSoFar.toStringAsFixed(0)}', Colors.white70),
                  _buildCostRow('Remaining', '₹${_remainingCost.toStringAsFixed(0)}', Colors.white70),
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 20),

            _buildSlider('Pads per cycle', _padsPerCycle, 5, 50, '${_padsPerCycle.round()} pads',
                (v) => setState(() => _padsPerCycle = v)),
            _buildSlider('Cost per pad (₹)', _padCost, 2, 30, '₹${_padCost.round()}',
                (v) => setState(() => _padCost = v)),
            _buildSlider('Painkillers per cycle (₹)', _painkillerCost, 0, 200, '₹${_painkillerCost.round()}',
                (v) => setState(() => _painkillerCost = v)),
            _buildSlider('Other (heating pad, food) ₹', _otherCost, 0, 500, '₹${_otherCost.round()}',
                (v) => setState(() => _otherCost = v)),
            _buildSlider('Age you started periods', _ageStarted.toDouble(), 9, 18, '$_ageStarted yrs',
                (v) => setState(() {
                      _ageStarted = v.round();
                      // Keep current age >= started age
                      if (_currentAge < _ageStarted) _currentAge = _ageStarted;
                    })),
            _buildSlider(
                'Your current age',
                _currentAge.toDouble().clamp(_ageStarted.toDouble(), 50),
                _ageStarted.toDouble(),
                50,
                '$_currentAge yrs',
                (v) => setState(() => _currentAge = v.round())),

            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.eco_rounded, color: AppColors.success, size: 22),
                      SizedBox(width: 8),
                      Text('Save Money & Earth', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Switch to a menstrual cup (₹400-800, lasts 5-10 years).',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Potential lifetime savings: ₹${(_lifetimeCost - 800).clamp(0, double.infinity).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 13)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, String displayValue,
      ValueChanged<double> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(displayValue, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.periodColor)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: AppColors.periodColor,
            onChanged: (v) {
              HapticUtils.selection();
              onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
