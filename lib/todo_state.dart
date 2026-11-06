import 'package:flutter/material.dart';

import 'task.dart';
import 'todo_repository.dart';

class TodoState extends ChangeNotifier {
  TodoRepository repo = TodoRepository();
  String filter = 'all';
  String search = '';
  String categoryFilter = 'Все';

  void load() async {
    await repo.load();
    notifyListeners();
  }

  List<Task> getTasks() {
    List<Task> list = [];

    for (var t in repo.getAll()) {
      if (filter == 'active' && t.done == true) {
        continue;
      }
      if (filter == 'done' && t.done == false) {
        continue;
      }
      if (categoryFilter != 'Все' && t.category != categoryFilter) {
        continue;
      }
      if (!t.title.toLowerCase().contains(search.toLowerCase())) {
        continue;
      }
      list.add(t);
    }

    return list;
  }

  void setFilter(String f) {
    filter = f;
    notifyListeners();
  }

  void setCategory(String c) {
    categoryFilter = c;
    notifyListeners();
  }

  void setSearch(String text) {
    search = text.trim();
    notifyListeners();
  }

  void addTask(String title, String priority, String category) {
    print('add ' + title);
    repo.add(title.trim(), priority, category);
    notifyListeners();
  }

  void editTask(int id, String title, String priority, String category) {
    repo.update(id, title.trim(), priority, category);
    notifyListeners();
  }

  void toggle(int id) {
    repo.toggle(id);
    notifyListeners();
  }

  void deleteTask(int id) {
    repo.delete(id);
    notifyListeners();
  }
}
