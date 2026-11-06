class Task {
  int id;
  String title;
  String priority;
  String category;
  bool done = false;
  DateTime created;

  Task(this.id, this.title, this.priority, this.category, this.created);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'category': category,
      'done': done,
      'created': created.toString(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    var t = Task(
      json['id'],
      json['title'],
      json['priority'],
      json['category'],
      DateTime.parse(json['created']),
    );
    t.done = json['done'];
    return t;
  }
}
