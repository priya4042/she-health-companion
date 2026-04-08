import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/health_tips.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../data/providers/medicine_provider.dart';
import '../../data/providers/period_provider.dart';
import '../../data/providers/profile_provider.dart';
import '../../data/providers/water_provider.dart';
import '../water_tracker/water_tracker_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final period = context.watch<PeriodProvider>();
    final medicine = context.watch<MedicineProvider>();
    final water = context.watch<WaterProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            _buildGreeting(context, profile.name),
            const SizedBox(height: 20),

            // Quick stats cards
            _buildQuickStats(context, period, medicine, water),
            const SizedBox(height: 24),

            // Water tracker quick access
            _buildWaterCard(context, water),
            const SizedBox(height: 24),

            // Today's health tip
            _buildHealthTipCard(context),
            const SizedBox(height: 24),

            // Today's medicines
            _buildTodayMedicines(context, medicine),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String name) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name.isNotEmpty ? name : 'Welcome!',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppDateUtils.formatDate(DateTime.now()),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    PeriodProvider period,
    MedicineProvider medicine,
    WaterProvider water,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.favorite_rounded,
            label: 'Period',
            value: period.isOnPeriod
                ? 'Day ${period.currentCycleDay}'
                : period.daysUntilNextPeriod != null
                    ? '${period.daysUntilNextPeriod}d left'
                    : 'Not set',
            color: AppColors.periodColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.medication_rounded,
            label: 'Medicine',
            value: '${medicine.todayTakenCount}/${medicine.todayTotalCount}',
            color: AppColors.medicineColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.water_drop_rounded,
            label: 'Water',
            value: '${water.todayGlasses}/${water.dailyGoal}',
            color: AppColors.waterColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterCard(BuildContext context, WaterProvider water) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WaterTrackerScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.waterColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Water Intake',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${water.todayMl} ml / ${water.goalMl} ml',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: water.todayProgress,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.water_drop_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTipCard(BuildContext context) {
    final categories = HealthTips.categories;
    final dayIndex = DateTime.now().day % categories.length;
    final category = categories[dayIndex];
    final tip = HealthTips.getDailyTip(category);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.healthColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded,
                  color: AppColors.healthColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Daily Health Tip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.healthColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.healthColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tip,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMedicines(BuildContext context, MedicineProvider medicine) {
    final doses = medicine.todayDoses;
    if (doses.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Medicines",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...doses.take(5).map((dose) {
          final medicineName = medicine.getMedicineName(dose.medicineId);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: dose.taken
                    ? AppColors.success.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: dose.taken
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.medicineColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    dose.taken
                        ? Icons.check_circle_rounded
                        : Icons.medication_rounded,
                    color: dose.taken
                        ? AppColors.success
                        : AppColors.medicineColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicineName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration:
                              dose.taken ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        AppDateUtils.formatTime(dose.scheduledTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!dose.taken)
                  TextButton(
                    onPressed: () => medicine.markDoseTaken(dose.id),
                    child: const Text('Take'),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
