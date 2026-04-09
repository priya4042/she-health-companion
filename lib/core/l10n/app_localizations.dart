import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Daily Life Helper',
      'home': 'Home',
      'period': 'Period',
      'mood': 'Mood',
      'reminders': 'Reminders',
      'profile': 'Profile',
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',
      'welcome': 'Welcome!',
      'period_tracker': 'Period Tracker',
      'medicine_reminders': 'Medicine Reminders',
      'water_tracker': 'Water Tracker',
      'sleep_tracker': 'Sleep Tracker',
      'health_tips': 'Health Tips',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'language': 'Language',
      'about': 'About',
      'bmi_calculator': 'BMI Calculator',
      'analytics': 'Health Analytics',
      'emergency_sos': 'Emergency SOS',
      'export_report': 'Health Report',
      'challenges': 'Challenges & Rewards',
      'app_lock': 'App Lock',
      'glasses': 'glasses',
      'days': 'days',
      'taken': 'Taken',
      'missed': 'Missed',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'add': 'Add',
      'edit': 'Edit',
      'name': 'Name',
      'age': 'Age',
      'cycle_length': 'Cycle Length',
      'period_duration': 'Period Duration',
      'daily_goal': 'Daily Goal',
      'how_are_you': 'How are you feeling?',
      'log_sleep': 'Log Your Sleep',
      'bedtime': 'Bedtime',
      'wake_up': 'Wake up',
    },
    'hi': {
      'app_name': 'डेली लाइफ हेल्पर',
      'home': 'होम',
      'period': 'पीरियड',
      'mood': 'मूड',
      'reminders': 'रिमाइंडर',
      'profile': 'प्रोफाइल',
      'good_morning': 'शुभ प्रभात',
      'good_afternoon': 'शुभ दोपहर',
      'good_evening': 'शुभ संध्या',
      'welcome': 'स्वागत है!',
      'period_tracker': 'पीरियड ट्रैकर',
      'medicine_reminders': 'दवा रिमाइंडर',
      'water_tracker': 'पानी ट्रैकर',
      'sleep_tracker': 'नींद ट्रैकर',
      'health_tips': 'स्वास्थ्य टिप्स',
      'settings': 'सेटिंग्स',
      'dark_mode': 'डार्क मोड',
      'light_mode': 'लाइट मोड',
      'language': 'भाषा',
      'about': 'ऐप के बारे में',
      'bmi_calculator': 'BMI कैलकुलेटर',
      'analytics': 'स्वास्थ्य एनालिटिक्स',
      'emergency_sos': 'इमरजेंसी SOS',
      'export_report': 'स्वास्थ्य रिपोर्ट',
      'challenges': 'चुनौतियाँ और पुरस्कार',
      'app_lock': 'ऐप लॉक',
      'glasses': 'गिलास',
      'days': 'दिन',
      'taken': 'लिया',
      'missed': 'छूट गया',
      'save': 'सेव करें',
      'cancel': 'रद्द करें',
      'delete': 'हटाएं',
      'add': 'जोड़ें',
      'edit': 'संपादित करें',
      'name': 'नाम',
      'age': 'उम्र',
      'cycle_length': 'चक्र की अवधि',
      'period_duration': 'पीरियड की अवधि',
      'daily_goal': 'दैनिक लक्ष्य',
      'how_are_you': 'आप कैसा महसूस कर रही हैं?',
      'log_sleep': 'नींद दर्ज करें',
      'bedtime': 'सोने का समय',
      'wake_up': 'जागने का समय',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  static List<Locale> get supportedLocales => const [
        Locale('en', ''),
        Locale('hi', ''),
      ];
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
