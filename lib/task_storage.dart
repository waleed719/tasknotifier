import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotifier/task.dart';

class TaskStorage {
  static const String _key = 'task_list';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Task.fromJson(e)).toList();
  }

  static Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
