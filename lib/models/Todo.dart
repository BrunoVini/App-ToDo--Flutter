class Todo {
  String title;
  String description;
  String status;

  Todo();

  Todo.fromTitleDescription(String title, String description) {
    this.title = title;
    this.description = description;
    this.status = 'A';
  }

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        status = json['status'];

  Map toJson() => {
        'title': title,
        'description': description,
        'status': status,
      };
}
