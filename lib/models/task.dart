class Task {
  final int id;
  final String title;
  final String course;
  final DateTime deadline;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    this.isCompleted = false,
  });
}
