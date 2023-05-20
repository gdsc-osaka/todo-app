// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
      title: json['title'] as String,
      description: json['description'] as String,
      until: const TimestampConverter().fromJson(json['until'] as Timestamp),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      status: const TaskStatusConverter().fromJson(json['status'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'title': instance.title,
      'description': instance.description,
      'until': const TimestampConverter().toJson(instance.until),
      'images': instance.images,
      'status': const TaskStatusConverter().toJson(instance.status),
    };
