import 'package:flutter/material.dart';

import 'edit_screen.dart';
import 'todo_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 183, 58, 114),
        ),
      ),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoState state = TodoState();
  List<String> categories = [
    'Все',
    'Дом',
    'Работа',
    'Учёба',
    'Семья',
    'Другое',
  ];

  @override
  void initState() {
    super.initState();
    state.addListener(() {
      setState(() {});
    });
    state.load();
  }

  String formatDate(DateTime d) {
    return d.day.toString() +
        '.' +
        d.month.toString() +
        '.' +
        d.year.toString() +
        ' ' +
        d.hour.toString() +
        ':' +
        d.minute.toString();
  }

  Color priorityColor(String p) {
    if (p == 'Высокий') {
      return Colors.red;
    }
    if (p == 'Средний') {
      return Colors.orange;
    }
    return Colors.green;
  }

  Widget filterButton(String text, String f) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: state.filter == f
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: state.filter == f ? Colors.white : null,
          ),
          onPressed: () {
            state.setFilter(f);
          },
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var tasks = state.getTasks();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Мои задачи'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск задачи...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                state.setSearch(text);
              },
            ),
          ),
          Row(
            children: [
              filterButton('Все', 'all'),
              filterButton('Активные', 'active'),
              filterButton('Готовые', 'done'),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text('Категория: '),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: state.categoryFilter,
                    isExpanded: true,
                    items: categories.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (v) {
                      state.setCategory(v!);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Text(tasks.length.toString()),
          if (tasks.isEmpty)
            Padding(padding: EdgeInsets.all(30), child: Text('Задач нет')),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                var t = tasks[i];
                return ListTile(
                  leading: Checkbox(
                    value: t.done,
                    onChanged: (v) {
                      state.toggle(t.id);
                    },
                  ),
                  title: Text(
                    t.title,
                    style: t.done == true
                        ? TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  subtitle: Wrap(
                    spacing: 10,
                    children: [
                      Text(formatDate(t.created)),
                      Text(
                        t.priority,
                        style: TextStyle(color: priorityColor(t.priority)),
                      ),
                      Text(t.category),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      state.deleteTask(t.id);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  onTap: () async {
                    var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScreen(task: t),
                      ),
                    );
                    if (res != null) {
                      state.editTask(
                        t.id,
                        res['title'],
                        res['priority'],
                        res['category'],
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditScreen()),
          );
          if (res != null) {
            state.addTask(res['title'], res['priority'], res['category']);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
