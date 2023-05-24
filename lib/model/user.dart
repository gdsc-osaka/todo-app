import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'user.g.dart';

@JsonSerializable()
class DBUser {
  DBUser({required this.createdAt, required this.updatedAt});

  @TimestampConverter()
  final Timestamp createdAt;
  @TimestampConverter()
  final Timestamp updatedAt;

  factory DBUser.fromJson(Map<String, dynamic> json) => _$DBUserFromJson(json);

  Map<String, dynamic> toJson() => _$DBUserToJson(this);

  static Map<String, dynamic> map() => {
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      };
}
