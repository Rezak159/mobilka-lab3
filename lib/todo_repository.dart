import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'task.dart';

class TodoRepository {
  List<Task> tasks = [];
  int lastId = 0;

  Future<void> load() async {
    var prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('tasks');
    if (data == null) {
      return;
    }

    List list = jsonDecode(data);
    tasks = list.map((e) => Task.fromJson(e)).toList();

    for (var t in tasks) {
      if (t.id > lastId) {
        lastId = t.id;
      }
    }
  }

  void save() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(tasks.map((t) => t.toJson()).toList()));
  }

  List<Task> getAll() {
    return tasks;
  }

  void add(String title, String priority, String category) {
    lastId++;
    tasks.add(Task(lastId, title, priority, category, DateTime.now()));
    save();
  }

  void update(int id, String title, String priority, String category) {
    for (var t in tasks) {
      if (t.id == id) {
        t.title = title;
        t.priority = priority;
        t.category = category;
      }
    }
    save();
  }

  void toggle(int id) {
    for (var t in tasks) {
      if (t.id == id) {
        t.done = !t.done;
      }
    }
    save();
  }

  void delete(int id) {
    tasks.removeWhere((t) => t.id == id);
    save();
  }
}
