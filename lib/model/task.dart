import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/model/json_converters.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  Task(
      {required this.createdAt,
      required this.updatedAt,
      required this.title,
      required this.description,
      required this.until,
      required this.images,
      required this.status});

  @TimestampConverter()
  final Timestamp createdAt;
  @TimestampConverter()
  final Timestamp updatedAt;
  final String title;
  final String description;
  @TimestampConverter()
  final Timestamp until;
  final List<String> images;
  @TaskStatusConverter()
  final TaskStatus status;
}

enum TaskStatus {
  undone('undone'),
  completed('completed');

  const TaskStatus(this.id);

  final String id;

  static Map<String, TaskStatus> enums = Map.fromIterables(TaskStatus.values.map((e) => e.id), TaskStatus.values);

  static TaskStatus fromString(String? value) {
    return enums[value] ?? TaskStatus.undone;
  }
}
