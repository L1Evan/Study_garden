import 'package:shared_preferences/shared_preferences.dart';

// This class handles lightweight settings (not database data)
// Use this for: themes, notifications, first-time flags
// Use DatabaseHelper for: plants, sessions, shop items

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  SharedPreferences? _prefs;

  // Initialize once
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Theme setting
  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool('dark_mode', value);
  }

  bool getDarkMode() {
    return _prefs?.getBool('dark_mode') ?? false;
  }

  // Notification time
  Future<void> setDailyReminderTime(String time) async {
    await _prefs?.setString('reminder_time', time);
  }

  String getDailyReminderTime() {
    return _prefs?.getString('reminder_time') ?? '09:00';
  }

  // First time user (for onboarding)
  Future<void> setFirstTime(bool value) async {
    await _prefs?.setBool('first_time', value);
  }

  bool isFirstTime() {
    return _prefs?.getBool('first_time') ?? true;
  }

  // Default session duration preference
  Future<void> setDefaultSessionDuration(int minutes) async {
    await _prefs?.setInt('default_session', minutes);
  }

  int getDefaultSessionDuration() {
    return _prefs?.getInt('default_session') ?? 25;
  }
}