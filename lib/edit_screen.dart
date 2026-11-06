import 'package:flutter/material.dart';

import 'task.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, this.task});

  final Task? task;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  String priority = 'Средний';
  String category = 'Дом';

  List<String> priorities = ['Высокий', 'Средний', 'Низкий'];
  List<String> categories = ['Дом', 'Работа', 'Учёба', 'Семья', 'Другое'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      controller.text = widget.task!.title;
      priority = widget.task!.priority;
      category = widget.task!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.task == null ? 'Новая задача' : 'Редактирование'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Название'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите название задачи';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text('Приоритет'),
            DropdownButton<String>(
              value: priority,
              isExpanded: true,
              items: priorities.map((p) {
                return DropdownMenuItem(value: p, child: Text(p));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  priority = v!;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Категория'),
            DropdownButton<String>(
              value: category,
              isExpanded: true,
              items: categories.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  category = v!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, {
                    'title': controller.text,
                    'priority': priority,
                    'category': category,
                  });
                }
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
