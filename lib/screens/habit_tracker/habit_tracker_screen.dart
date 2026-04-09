import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/providers/habit_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  static const _presetHabits = [
    {'name': 'Morning Walk', 'icon': '🚶‍♀️', 'color': '4CAF50'},
    {'name': 'Vitamins', 'icon': '💊', 'color': 'FF9800'},
    {'name': 'Skincare', 'icon': '🧴', 'color': 'E91E63'},
    {'name': 'Exercise', 'icon': '🏋️‍♀️', 'color': '2196F3'},
    {'name': 'Meditation', 'icon': '🧘‍♀️', 'color': '9C27B0'},
    {'name': 'Read', 'icon': '📚', 'color': '795548'},
    {'name': 'No Junk Food', 'icon': '🥗', 'color': '4CAF50'},
    {'name': 'Early Sleep', 'icon': '😴', 'color': '5C6BC0'},
    {'name': 'Hair Oil', 'icon': '💆‍♀️', 'color': 'FF5722'},
    {'name': 'Yoga', 'icon': '🧘', 'color': '00BCD4'},
    {'name': 'Journaling', 'icon': '📝', 'color': 'FFC107'},
    {'name': 'No Screen', 'icon': '📵', 'color': '607D8B'},
  ];

  @override
  Widget build(BuildContext context) {
    final habit = context.watch<HabitProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress card
            _buildProgressCard(habit)
                .animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 24),

            // Today's habits
            if (habit.habits.isNotEmpty) ...[
              const Text("Today's Habits", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildHabitGrid(context, habit),
              const SizedBox(height: 24),
            ],

            // Add habit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add New Habit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => _showCustomHabitDialog(context, habit),
                  icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                  tooltip: 'Custom habit',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPresetGrid(context, habit),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(HabitProvider habit) {
    final progress = habit.todayProgress;
    final completed = habit.todayCompletedCount;
    final total = habit.habits.length;

    return GradientCard(
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B9D), Color(0xFFC850C0)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Progress", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      total > 0 ? '$completed of $total done' : 'No habits yet',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitGrid(BuildContext context, HabitProvider habit) {
    return AnimationLimiter(
      child: Column(
        children: List.generate(habit.habits.length, (i) {
          final h = habit.habits[i];
          final isDone = habit.isCompletedToday(h.id);
          final streak = habit.getStreak(h.id);
          final color = Color(int.parse('FF${h.color}', radix: 16));

          return AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 300),
            child: SlideAnimation(
              verticalOffset: 20,
              child: FadeInAnimation(
                child: GlassCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  onTap: () {
                    HapticUtils.lightTap();
                    habit.toggleCompletion(h.id);
                  },
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDone ? color.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: isDone ? Border.all(color: color, width: 2) : null,
                        ),
                        child: Center(
                          child: isDone
                              ? Icon(Icons.check_circle, color: color, size: 24)
                              : Text(h.icon, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                                color: isDone ? Colors.grey : null,
                              ),
                            ),
                            if (streak > 0)
                              Text('🔥 $streak day streak',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      // Weekly dots
                      Row(
                        children: habit.getWeeklyData(h.id).values.map((done) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done ? color : Colors.grey.withValues(alpha: 0.2),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _confirmDelete(context, h.id, h.name, habit),
                        icon: Icon(Icons.close, size: 16, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPresetGrid(BuildContext context, HabitProvider habit) {
    final existingNames = habit.allHabits.map((h) => h.name).toSet();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _presetHabits.where((p) => !existingNames.contains(p['name'])).map((preset) {
        final color = Color(int.parse('FF${preset['color']}', radix: 16));
        return GestureDetector(
          onTap: () {
            HapticUtils.lightTap();
            habit.addHabit(
              name: preset['name']!,
              icon: preset['icon']!,
              color: preset['color']!,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(preset['icon']!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(preset['name']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
                const SizedBox(width: 4),
                Icon(Icons.add_circle_outline, size: 14, color: color),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showCustomHabitDialog(BuildContext context, HabitProvider habit) {
    final nameController = TextEditingController();
    String selectedIcon = '⭐';
    String selectedColor = 'E91E63';

    final icons = ['⭐', '💪', '🏃‍♀️', '🍎', '💤', '📖', '🎯', '🧹', '🌸', '💅', '🥤', '🎵'];
    final colors = ['E91E63', '9C27B0', '2196F3', '4CAF50', 'FF9800', '795548', '00BCD4', '5C6BC0'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Custom Habit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Habit Name', prefixIcon: Icon(Icons.edit)),
              ),
              const SizedBox(height: 16),
              const Text('Pick Icon', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: icons.map((icon) => GestureDetector(
                      onTap: () => setSheetState(() => selectedIcon = icon),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: selectedIcon == icon ? Border.all(color: AppColors.primary, width: 2) : null,
                          color: selectedIcon == icon ? AppColors.primary.withValues(alpha: 0.1) : null,
                        ),
                        child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
                      ),
                    )).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Pick Color', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: colors.map((c) {
                  final color = Color(int.parse('FF$c', radix: 16));
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedColor = c),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == c ? Border.all(color: Colors.white, width: 3) : null,
                        boxShadow: selectedColor == c
                            ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)]
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    habit.addHabit(
                      name: nameController.text.trim(),
                      icon: selectedIcon,
                      color: selectedColor,
                    );
                    Navigator.pop(ctx);
                  },
                  child: const Text('Add Habit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, String name, HabitProvider habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Habit?'),
        content: Text('Remove "$name" and all its history?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              habit.deleteHabit(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
