class MotivationalQuotes {
  MotivationalQuotes._();

  static const List<Map<String, String>> _quotes = [
    {'quote': 'Take care of your body. It\'s the only place you have to live.', 'author': 'Jim Rohn'},
    {'quote': 'Health is not valued till sickness comes.', 'author': 'Thomas Fuller'},
    {'quote': 'The greatest wealth is health.', 'author': 'Virgil'},
    {'quote': 'A healthy outside starts from the inside.', 'author': 'Robert Urich'},
    {'quote': 'Your body hears everything your mind says. Stay positive.', 'author': 'Naomi Judd'},
    {'quote': 'Self-care is not selfish. You cannot serve from an empty vessel.', 'author': 'Eleanor Brown'},
    {'quote': 'Drink water, eat well, sleep enough, and love yourself.', 'author': 'Unknown'},
    {'quote': 'Small daily improvements are the key to staggering long-term results.', 'author': 'Unknown'},
    {'quote': 'The only bad workout is the one that didn\'t happen.', 'author': 'Unknown'},
    {'quote': 'Your health is an investment, not an expense.', 'author': 'Unknown'},
    {'quote': 'Happiness is the highest form of health.', 'author': 'Dalai Lama'},
    {'quote': 'Let food be thy medicine and medicine be thy food.', 'author': 'Hippocrates'},
    {'quote': 'It is health that is real wealth and not pieces of gold and silver.', 'author': 'Mahatma Gandhi'},
    {'quote': 'A fit body, a calm mind, a house full of love – these cannot be bought.', 'author': 'Naval Ravikant'},
    {'quote': 'You are what you eat, so don\'t be fast, cheap, easy, or fake.', 'author': 'Unknown'},
    {'quote': 'Rest when you\'re weary. Refresh and renew yourself, your body, your mind.', 'author': 'Ralph Marston'},
    {'quote': 'Almost everything will work again if you unplug it for a few minutes, including you.', 'author': 'Anne Lamott'},
    {'quote': 'Wellness is the complete integration of body, mind, and spirit.', 'author': 'Greg Anderson'},
    {'quote': 'To keep the body in good health is a duty.', 'author': 'Buddha'},
    {'quote': 'When the heart is at ease, the body is healthy.', 'author': 'Chinese Proverb'},
    {'quote': 'Good health and good sense are two of life\'s greatest blessings.', 'author': 'Publilius Syrus'},
    {'quote': 'Water is the driving force of all nature.', 'author': 'Leonardo da Vinci'},
    {'quote': 'Sleep is the golden chain that ties health and our bodies together.', 'author': 'Thomas Dekker'},
    {'quote': 'Healing is a matter of time, but it is sometimes also a matter of opportunity.', 'author': 'Hippocrates'},
    {'quote': 'She believed she could, so she did.', 'author': 'R.S. Grey'},
    {'quote': 'You don\'t have to be perfect to be amazing.', 'author': 'Unknown'},
    {'quote': 'Be gentle with yourself. You\'re doing the best you can.', 'author': 'Unknown'},
    {'quote': 'Every day is a new chance to make healthy choices.', 'author': 'Unknown'},
    {'quote': 'Progress, not perfection, is what we should be asking of ourselves.', 'author': 'Julia Cameron'},
    {'quote': 'Nourishing yourself in a way that helps you blossom is attainable and worth it.', 'author': 'Unknown'},
  ];

  static Map<String, String> getQuoteOfTheDay() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return _quotes[dayOfYear % _quotes.length];
  }

  static Map<String, String> getRandomQuote() {
    final index = DateTime.now().millisecondsSinceEpoch % _quotes.length;
    return _quotes[index];
  }

  static List<Map<String, String>> get allQuotes => _quotes;
}
