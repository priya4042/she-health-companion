/// Static health tips organized by category.
/// Can be replaced with an API call in the future.
class HealthTips {
  HealthTips._();

  static const Map<String, List<String>> tips = {
    'PCOD': [
      'Maintain a healthy weight – even 5% weight loss can improve PCOD symptoms significantly.',
      'Include anti-inflammatory foods like turmeric, green leafy vegetables, and berries in your diet.',
      'Exercise for at least 30 minutes daily – walking, yoga, or swimming are great options.',
      'Limit refined carbs and sugar to manage insulin resistance.',
      'Get 7-8 hours of quality sleep every night to help regulate hormones.',
      'Practice stress management through meditation or deep breathing exercises.',
      'Include omega-3 fatty acids from flaxseeds, walnuts, or fish in your diet.',
      'Drink spearmint tea – studies suggest it may help reduce excess androgens.',
      'Avoid processed and junk food as they can worsen inflammation.',
      'Regular health checkups and blood tests are important for PCOD management.',
      'Include cinnamon in your diet – it may help improve insulin sensitivity.',
      'Stay hydrated – drink at least 8 glasses of water daily.',
      'Reduce caffeine intake as it can affect hormone levels.',
      'Include probiotics through curd or fermented foods for gut health.',
      'Track your periods regularly to identify pattern changes early.',
    ],
    'Hair Care': [
      'Oil your hair with coconut or castor oil at least twice a week.',
      'Avoid washing hair with hot water – use lukewarm or cool water instead.',
      'Include protein-rich foods like eggs, dal, and paneer for stronger hair.',
      'Use a wide-toothed comb on wet hair to prevent breakage.',
      'Trim your hair every 6-8 weeks to prevent split ends.',
      'Minimize heat styling – air dry your hair whenever possible.',
      'Apply a homemade hair mask with curd and honey once a week.',
      'Biotin-rich foods like almonds and sweet potatoes promote hair growth.',
      'Protect your hair from sun and pollution with a scarf or hat.',
      'Avoid tight hairstyles that pull on your hairline.',
      'Amla (Indian gooseberry) is excellent for hair health – eat it or apply its oil.',
      'Do not brush your hair when it is wet – let it dry partially first.',
      'Use a silk pillowcase to reduce friction and hair breakage while sleeping.',
      'Iron deficiency can cause hair loss – include spinach and jaggery in your diet.',
      'Fenugreek (methi) seeds soaked overnight make a great hair mask.',
    ],
    'Skin Care': [
      'Apply sunscreen with SPF 30+ every day, even on cloudy days.',
      'Drink adequate water – hydration is the foundation of glowing skin.',
      'Remove makeup before sleeping to prevent clogged pores and breakouts.',
      'Include vitamin C rich fruits like amla, orange, and guava for bright skin.',
      'Use aloe vera gel as a natural moisturizer and skin soother.',
      'Exfoliate gently 1-2 times a week to remove dead skin cells.',
      'Get enough sleep – skin repairs itself during rest.',
      'Apply turmeric and besan (gram flour) face pack for natural glow.',
      'Avoid touching your face frequently to prevent bacteria transfer.',
      'Rose water is a gentle natural toner – apply it after cleansing.',
      'Include healthy fats from nuts and seeds for supple skin.',
      'Neem has antibacterial properties – use neem face wash for acne-prone skin.',
      'Multani mitti (fuller\'s earth) is excellent for oily skin.',
      'Avoid excessive sugar – it can accelerate skin aging.',
      'Tomato pulp applied on skin can help reduce tan and dark spots.',
    ],
    'General Health': [
      'Walk at least 10,000 steps daily for overall fitness.',
      'Eat a balanced breakfast – it sets the tone for your entire day.',
      'Practice deep breathing for 5 minutes every morning.',
      'Include seasonal fruits and vegetables in your diet.',
      'Limit screen time before bed for better sleep quality.',
      'Take short breaks every hour if you have a desk job.',
      'Include dal, curd, and vegetables in every meal for balanced nutrition.',
      'Maintain good posture while sitting and standing.',
      'Wash hands frequently, especially before eating.',
      'Regular health checkups can catch problems early.',
      'Eat dinner at least 2 hours before sleeping.',
      'Include tulsi (holy basil) tea for immunity boosting.',
      'Chew your food properly – aim for 20-30 chews per bite.',
      'Take stairs instead of elevators whenever possible.',
      'Spend 15-20 minutes in morning sunlight for vitamin D.',
    ],
  };

  /// Get a daily tip based on the day of year and category
  static String getDailyTip(String category) {
    final dayOfYear = DateTime.now().difference(
      DateTime(DateTime.now().year, 1, 1),
    ).inDays;
    final categoryTips = tips[category] ?? tips['General Health']!;
    return categoryTips[dayOfYear % categoryTips.length];
  }

  /// Get all tips for a category
  static List<String> getTips(String category) {
    return tips[category] ?? [];
  }

  /// Get all categories
  static List<String> get categories => tips.keys.toList();
}
