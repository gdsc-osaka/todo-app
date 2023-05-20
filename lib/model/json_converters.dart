import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/model/task.dart';

class TimestampConverter implements JsonConverter<Timestamp, Timestamp> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Timestamp? value) {
    return value!;
  }

  @override
  Timestamp toJson(Timestamp timestamp) {
    return timestamp;
  }
}

class TaskStatusConverter implements JsonConverter<TaskStatus, String> {
  const TaskStatusConverter();

  @override
  TaskStatus fromJson(String? value) {
    return TaskStatus.fromString(value);
  }

  @override
  String toJson(TaskStatus taskStatus) {
    return taskStatus.id;
  }
}
