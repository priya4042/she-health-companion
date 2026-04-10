import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  static const _recipes = {
    'North Indian': [
      {
        'name': 'Palak Paneer',
        'benefit': 'Iron-rich for periods',
        'time': '30 min',
        'ingredients': 'Spinach, paneer, ginger, garlic, cumin, garam masala',
        'desc': 'Spinach is loaded with iron — perfect for replenishing during periods.',
      },
      {
        'name': 'Chana Masala',
        'benefit': 'Protein for PCOD',
        'time': '40 min',
        'ingredients': 'Chickpeas, onion, tomato, ginger, cumin, coriander',
        'desc': 'High protein and fiber, helps regulate blood sugar.',
      },
      {
        'name': 'Methi Paratha',
        'benefit': 'Hormonal balance',
        'time': '25 min',
        'ingredients': 'Wheat flour, fenugreek leaves, ajwain, ghee',
        'desc': 'Methi helps reduce period pain and balance hormones.',
      },
    ],
    'South Indian': [
      {
        'name': 'Ragi Dosa',
        'benefit': 'Calcium-rich',
        'time': '20 min',
        'ingredients': 'Ragi flour, rice, urad dal, salt',
        'desc': 'Ragi is rich in calcium and iron — excellent for bone and blood health.',
      },
      {
        'name': 'Drumstick Sambar',
        'benefit': 'Iron and vitamins',
        'time': '35 min',
        'ingredients': 'Toor dal, drumstick, tamarind, sambar masala',
        'desc': 'Drumstick is a superfood for women, rich in iron and calcium.',
      },
      {
        'name': 'Coconut Curry',
        'benefit': 'Healthy fats',
        'time': '25 min',
        'ingredients': 'Coconut milk, vegetables, curry leaves, mustard seeds',
        'desc': 'Healthy fats from coconut support hormone production.',
      },
    ],
    'East Indian': [
      {
        'name': 'Macher Jhol',
        'benefit': 'Omega-3 rich',
        'time': '30 min',
        'ingredients': 'Fish, potato, tomato, mustard oil, panch phoron',
        'desc': 'Fish provides omega-3 fatty acids — reduces period inflammation.',
      },
      {
        'name': 'Aloo Posto',
        'benefit': 'Calcium boost',
        'time': '25 min',
        'ingredients': 'Potato, poppy seeds, mustard oil, green chili',
        'desc': 'Poppy seeds are packed with calcium and magnesium.',
      },
    ],
    'West Indian': [
      {
        'name': 'Khichdi',
        'benefit': 'Easy digestion',
        'time': '25 min',
        'ingredients': 'Rice, moong dal, ghee, cumin, turmeric',
        'desc': 'Light and nutritious — perfect for period days when digestion is sensitive.',
      },
      {
        'name': 'Dhokla',
        'benefit': 'Probiotic-rich',
        'time': '30 min',
        'ingredients': 'Besan, curd, mustard seeds, curry leaves',
        'desc': 'Fermented food helps gut health and PCOD management.',
      },
      {
        'name': 'Bajra Roti',
        'benefit': 'Iron and fiber',
        'time': '20 min',
        'ingredients': 'Bajra (millet) flour, water, ghee',
        'desc': 'Millet is iron-rich and helps with period fatigue.',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _recipes.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Healthy Recipes'),
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: _recipes.keys.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: TabBarView(
          children: _recipes.entries.map((entry) {
            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: entry.value.length,
                itemBuilder: (context, i) {
                  final recipe = entry.value[i];
                  return AnimationConfiguration.staggeredList(
                    position: i,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 30,
                      child: FadeInAnimation(
                        child: _buildRecipeCard(recipe, context),
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, String> recipe, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.healthColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.restaurant_rounded, color: AppColors.healthColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(recipe['time']!,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, size: 12, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(recipe['benefit']!,
                      style: const TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(recipe['desc']!,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.kitchen, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(recipe['ingredients']!,
                        style: const TextStyle(fontSize: 12, color: AppColors.primary)),
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
