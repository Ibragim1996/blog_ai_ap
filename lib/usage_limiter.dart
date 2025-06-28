import 'package:shared_preferences/shared_preferences.dart';

class UsageLimiter {
  static String _getTodayKey() {
    final now = DateTime.now();
    return 'tasks_${now.year}_${now.month}_${now.day}';
  }

  static Future<int> getTodayCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_getTodayKey()) ?? 0;
  }

  static Future<void> increment() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _getTodayKey();
    int count = prefs.getInt(todayKey) ?? 0;
    count += 1;
    await prefs.setInt(todayKey, count);
  }

  // Добавь эту функцию для бонуса
  static Future<void> addBonusTasks(int bonus) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _getTodayKey();
    int count = prefs.getInt(todayKey) ?? 0;
    count += bonus;
    await prefs.setInt(todayKey, count);
  }
}
