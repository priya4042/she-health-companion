import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/utils/haptic_utils.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  double _height = 165; // cm
  double _weight = 60; // kg
  double? _bmi;
  String _category = '';
  Color _categoryColor = AppColors.bmiColor;
  String _healthTip = '';

  void _calculateBMI() {
    HapticUtils.mediumTap();
    final heightM = _height / 100;
    final bmi = _weight / (heightM * heightM);
    setState(() {
      _bmi = bmi;
      _updateCategory(bmi);
    });
  }

  void _updateCategory(double bmi) {
    if (bmi < 18.5) {
      _category = 'Underweight';
      _categoryColor = AppColors.info;
      _healthTip =
          'You may need to gain weight. Include protein-rich foods, healthy fats, and eat more frequently.';
    } else if (bmi < 24.9) {
      _category = 'Normal';
      _categoryColor = AppColors.success;
      _healthTip =
          'Great job! Maintain your healthy weight with balanced nutrition and regular exercise.';
    } else if (bmi < 29.9) {
      _category = 'Overweight';
      _categoryColor = AppColors.warning;
      _healthTip =
          'Consider increasing physical activity and reducing calorie intake. Small changes make a big difference.';
    } else {
      _category = 'Obese';
      _categoryColor = AppColors.error;
      _healthTip =
          'Consult a healthcare professional. Focus on gradual lifestyle changes – diet, exercise, and sleep.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Height slider
            GlassCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Height',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${_height.round()} cm',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bmiColor,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _height,
                    min: 100,
                    max: 220,
                    divisions: 120,
                    activeColor: AppColors.bmiColor,
                    onChanged: (v) {
                      HapticUtils.selection();
                      setState(() => _height = v);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('100 cm', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      Text('220 cm', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 16),

            // Weight slider
            GlassCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weight',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${_weight.round()} kg',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bmiColor,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _weight,
                    min: 30,
                    max: 200,
                    divisions: 170,
                    activeColor: AppColors.bmiColor,
                    onChanged: (v) {
                      HapticUtils.selection();
                      setState(() => _weight = v);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('30 kg', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      Text('200 kg', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            const SizedBox(height: 24),

            // Calculate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bmiColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Calculate BMI',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 30),

            // Result
            if (_bmi != null) ...[
              // Gauge
              _buildGauge().animate().fadeIn(duration: 600.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    curve: Curves.elasticOut,
                    duration: 800.ms,
                  ),
              const SizedBox(height: 20),

              // Result card
              GradientCard(
                gradient: LinearGradient(
                  colors: [
                    _categoryColor,
                    _categoryColor.withValues(alpha: 0.7),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _bmi!.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _healthTip,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.15),
              const SizedBox(height: 16),

              // Ideal weight range
              GlassCard(
                child: Column(
                  children: [
                    const Text(
                      'Ideal Weight Range',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_idealWeightRange()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      'Based on your height of ${_height.round()} cm',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGauge() {
    return SizedBox(
      height: 250,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 1500,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 10,
            maximum: 45,
            startAngle: 150,
            endAngle: 30,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 10,
                endValue: 18.5,
                color: AppColors.info,
                label: 'Under',
                labelStyle: const GaugeTextStyle(fontSize: 10, color: Colors.white),
              ),
              GaugeRange(
                startValue: 18.5,
                endValue: 24.9,
                color: AppColors.success,
                label: 'Normal',
                labelStyle: const GaugeTextStyle(fontSize: 10, color: Colors.white),
              ),
              GaugeRange(
                startValue: 24.9,
                endValue: 29.9,
                color: AppColors.warning,
                label: 'Over',
                labelStyle: const GaugeTextStyle(fontSize: 10, color: Colors.white),
              ),
              GaugeRange(
                startValue: 29.9,
                endValue: 45,
                color: AppColors.error,
                label: 'Obese',
                labelStyle: const GaugeTextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: _bmi!.clamp(10, 45),
                enableAnimation: true,
                animationDuration: 1200,
                animationType: AnimationType.elasticOut,
                needleColor: _categoryColor,
                needleLength: 0.7,
                knobStyle: KnobStyle(
                  color: _categoryColor,
                  borderColor: Colors.white,
                  borderWidth: 0.02,
                  knobRadius: 0.06,
                ),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  _bmi!.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _categoryColor,
                  ),
                ),
                angle: 90,
                positionFactor: 0.45,
              ),
            ],
            axisLabelStyle: const GaugeTextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  String _idealWeightRange() {
    final heightM = _height / 100;
    final minWeight = (18.5 * heightM * heightM).toStringAsFixed(1);
    final maxWeight = (24.9 * heightM * heightM).toStringAsFixed(1);
    return '$minWeight - $maxWeight kg';
  }
}
