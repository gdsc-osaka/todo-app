import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:todo_app/model/user.dart';
import 'package:todo_app/model/with_converter_ex.dart';
import 'package:uuid/uuid.dart';

import '../model/task.dart';

// DocumentReference _taskRef(String uid, String taskId) {
//
// }

class FirestoreAPI {
  static final instance = FirestoreAPI();

  Future<void> addTask(User user,
      {required String title, required String description, required DateTime until, required List<File> images}) async {

  }

  Future<void> addUser(User user) async {

  }

  Future<void> deleteTask(User user, String taskId) async {

  }

  Future<void> updateTask(User user, String taskId, Map<String, dynamic> data) async {

  }
}
