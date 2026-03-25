import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Session duration
  int getDefaultSessionDuration() {
    return _prefs?.getInt('default_session') ?? 25;
  }

  Future<void> setDefaultSessionDuration(int minutes) async {
    await _prefs?.setInt('default_session', minutes);
  }

  // Dark mode
  bool getDarkMode() {
    return _prefs?.getBool('dark_mode') ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool('dark_mode', value);
  }

  // First time user (for onboarding)
  bool isFirstTime() {
    return _prefs?.getBool('first_time') ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    await _prefs?.setBool('first_time', value);
  }

  // Daily reminder time
  String getDailyReminderTime() {
    return _prefs?.getString('reminder_time') ?? '09:00';
  }

  Future<void> setDailyReminderTime(String time) async {
    await _prefs?.setString('reminder_time', time);
  }
}