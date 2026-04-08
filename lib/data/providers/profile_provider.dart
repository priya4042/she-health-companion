import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';

class ProfileProvider extends ChangeNotifier {
  late Box _profileBox;
  late Box _settingsBox;

  String _name = '';
  int _age = 0;
  bool _onboardingDone = false;

  ProfileProvider() {
    _profileBox = Hive.box(AppConstants.profileBox);
    _settingsBox = Hive.box(AppConstants.settingsBox);
    _loadProfile();
  }

  String get name => _name;
  int get age => _age;
  bool get onboardingDone => _onboardingDone;

  void _loadProfile() {
    _name = _profileBox.get(AppConstants.keyName, defaultValue: '');
    _age = _profileBox.get(AppConstants.keyAge, defaultValue: 0);
    _onboardingDone = _settingsBox.get(AppConstants.keyOnboardingDone, defaultValue: false);
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required int age}) async {
    _name = name;
    _age = age;
    await _profileBox.put(AppConstants.keyName, name);
    await _profileBox.put(AppConstants.keyAge, age);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    await _settingsBox.put(AppConstants.keyOnboardingDone, true);
    notifyListeners();
  }
}
