import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_card.dart';

class MomModeScreen extends StatelessWidget {
  const MomModeScreen({super.key});

  static const _topics = [
    {
      'icon': '🌸',
      'title': 'What is a period?',
      'short': 'Understanding menstruation',
      'content': '''A period is a natural part of growing up for every girl. It happens once a month when your body sheds the lining of your uterus.

Here's what to expect:
• Bleeding lasts 3-7 days
• It's completely normal and healthy
• Every girl experiences it differently
• It usually starts between ages 9-15

Remember: Periods are NOT something to be ashamed of. They are a sign your body is healthy and working perfectly!''',
    },
    {
      'icon': '🩹',
      'title': 'How to use a pad?',
      'short': 'Step-by-step guide',
      'content': '''Using a pad is easy! Here's how:

1. Wash your hands first
2. Open the pad wrapper
3. Peel off the strip from the back
4. Stick the sticky side to your underwear
5. If it has wings, fold them under
6. Change every 4-6 hours

Tips:
• Always carry an extra pad in your bag
• Change pads regularly to stay fresh
• Wrap used pads in tissue before throwing away
• Wash hands after changing''',
    },
    {
      'icon': '🤔',
      'title': 'Is cramping normal?',
      'short': 'Understanding period pain',
      'content': '''Yes, mild cramps are very normal! They happen because your uterus is contracting.

What you can do:
• Use a hot water bottle on your tummy
• Drink warm water or ginger tea
• Rest and relax
• Eat warm, light food
• Take a warm bath

When to tell mom:
• Pain is so bad you can\'t go to school
• Bleeding is very heavy
• Cramps last more than 3 days
• You feel dizzy or faint

Don't worry — you can talk to mom about anything!''',
    },
    {
      'icon': '🛁',
      'title': 'Period hygiene',
      'short': 'Stay clean and fresh',
      'content': '''Good hygiene during your period is important:

Daily:
• Take a bath every day
• Change pads every 4-6 hours
• Wash hands before and after changing
• Wear clean cotton underwear

Don't:
• Don\'t use scented products
• Don\'t wear the same pad all day
• Don\'t hide soiled pads in your room

Talk to mom if:
• You feel itchy or burning
• You see unusual color
• You smell something different''',
    },
    {
      'icon': '🍎',
      'title': 'What to eat?',
      'short': 'Period-friendly foods',
      'content': '''Eating right helps you feel better during periods!

Eat more:
• Fruits (apples, bananas, oranges)
• Vegetables (spinach, palak)
• Dal and curd
• Nuts (almonds, walnuts)
• Warm milk with turmeric
• Iron-rich foods (jaggery, dates)

Avoid:
• Cold drinks and ice cream
• Too much sugar
• Fried/junk food
• Caffeine

Drink lots of water!''',
    },
    {
      'icon': '🤗',
      'title': 'Talking to mom',
      'short': 'It\'s okay to ask for help',
      'content': '''Your mom is your best friend during this time. Here's how to talk to her:

What to say:
• "Mom, I got my period today"
• "Can you help me with pads?"
• "I have stomach pain, can you help?"
• "I have a question about my body"

Remember:
• Mom went through this too
• She understands everything
• Asking for help is brave, not embarrassing
• There are no silly questions

Your mom loves you and will always help! ❤️''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mom & Me')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB74D), Color(0xFFF06292)],
              ),
              child: const Row(
                children: [
                  Text('👩‍👧', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mother-Daughter Mode',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Educational content for young girls',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),

            const Text('Learn About Your Body',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),

            AnimationLimiter(
              child: Column(
                children: List.generate(_topics.length, (i) {
                  final topic = _topics[i];
                  return AnimationConfiguration.staggeredList(
                    position: i,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 30,
                      child: FadeInAnimation(
                        child: GlassCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          onTap: () => _showTopicDetail(context, topic),
                          child: Row(
                            children: [
                              Container(
                                width: 56, height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.moodColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(child: Text(topic['icon']!, style: const TextStyle(fontSize: 28))),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(topic['title']!,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Text(topic['short']!,
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTopicDetail(BuildContext context, Map<String, String> topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        expand: false,
        builder: (_, scroll) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scroll,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: Text(topic['icon']!, style: const TextStyle(fontSize: 60))),
              const SizedBox(height: 12),
              Text(topic['title']!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Text(topic['content']!,
                  style: const TextStyle(fontSize: 15, height: 1.7)),
            ],
          ),
        ),
      ),
    );
  }
}
