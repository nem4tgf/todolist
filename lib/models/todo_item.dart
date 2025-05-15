class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});

  Map<String, dynamic> toJson() => {
    'title': title,
    'isDone': isDone,
  };

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      title: json['title'],
      isDone: json['isDone'],
    );
  }
}
