import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Future<void> initialize() async {
    await _settingsService.init();
    _isDarkMode = _settingsService.getDarkMode();
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    await _settingsService.setDarkMode(value);
  }
}