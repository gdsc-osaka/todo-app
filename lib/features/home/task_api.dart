import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../model/task.dart';

const uuid = Uuid();

Future<void> addTask(User user, {
  required String title,
  required String description,
  required DateTime until,
  required List<File> images
}) async {
  final imageUUIDList = images.map((e) => uuid.v4()).toList();
  final imagePathList = imageUUIDList.map((id) => "${user.uid}/$id").toList();

  final task = Task(
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      title: title,
      description: description,
      until: Timestamp.fromDate(until),
      images: imagePathList,
      status: TaskStatus.undone);


}