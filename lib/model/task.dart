import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/model/json_converters.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  Task(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.title,
      required this.description,
      required this.until,
      required this.images,
      required this.status});

  final String id;
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

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  static Map<String, dynamic> map(
      {required bool update, String? id, String? title, String? description, DateTime? until, List<String>? images, TaskStatus? status}) {
    final map = <String, dynamic>{
      "updatedAt": FieldValue.serverTimestamp(),
    };

    if (!update) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }

    if (id != null) map['id'] = id;
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (until != null) map['until'] = Timestamp.fromDate(until);
    if (images != null) map['images'] = images;
    if (status != null) map['status'] = status.id;

    return map;
  }
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
