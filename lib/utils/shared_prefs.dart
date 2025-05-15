import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';

class SharedPrefs {
  static const _key = 'todo_list';

  static Future<void> saveTodoList(List<TodoItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, data);
  }

  static Future<List<TodoItem>> loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data != null) {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => TodoItem.fromJson(e)).toList();
    }
    return [];
  }
}
