import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  late Box _settingsBox;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _settingsBox = Hive.box(AppConstants.settingsBox);
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    final themeIndex = _settingsBox.get(AppConstants.keyThemeMode, defaultValue: 0);
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _settingsBox.put(AppConstants.keyThemeMode, _themeMode.index);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _settingsBox.put(AppConstants.keyThemeMode, mode.index);
    notifyListeners();
  }
}
