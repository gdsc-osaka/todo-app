class Task {
  Task(
      {required this.createdAt,
      required this.updatedAt,
      required this.title,
      required this.description,
      required this.until,
      required this.images,
      required this.status});

  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String description;
  final DateTime until;
  final List<String> images;
  final TaskStatus status;
}

enum TaskStatus {
  undone,
  completed;
}
