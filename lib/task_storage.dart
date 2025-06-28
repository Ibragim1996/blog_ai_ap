import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class TaskStorage {
  static const _key = 'completedTasks';

  // Сохраняет задание с путём к видео и временной меткой
  static Future<void> saveCompletedTask(
    String taskText,
    String videoPath,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_key) ?? [];

    final Map<String, String> newTask = {
      'task': taskText,
      'videoPath': videoPath,
      'timestamp': DateTime.now().toIso8601String(),
    };

    existing.add(jsonEncode(newTask));
    await prefs.setStringList(_key, existing);
  }

  static Future<List<Map<String, dynamic>>> loadCompletedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList(_key) ?? [];

    final now = DateTime.now();
    final List<Map<String, dynamic>> filtered = [];

    for (final jsonStr in rawList) {
      try {
        final Map<String, dynamic> task = jsonDecode(jsonStr);
        final timestamp = DateTime.tryParse(task['timestamp'] ?? '');
        final path = task['videoPath'];

        final isValidTime =
            timestamp != null && now.difference(timestamp).inHours < 24;
        final fileExists = path != null && File(path).existsSync();

        if (isValidTime && fileExists) {
          filtered.add(task);
        }
      } catch (_) {
        // если ошибка — пропускаем
      }
    }

    return filtered;
  }

  // Удаляет задачу по индексу
  static Future<void> deleteTaskAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_key) ?? [];

    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await prefs.setStringList(_key, list);
    }
  }

  // Полная очистка всех заданий
  static Future<void> clearAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
