import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/model/user.dart';
import 'package:todo_app/model/with_converter_ex.dart';
import 'package:uuid/uuid.dart';

import '../../model/task.dart';

const _uuid = Uuid();
final _db = FirebaseFirestore.instance;
final _users = _db.collection('users');

DocumentReference _taskRef(String uid, String taskId) {
  return _users.doc(uid).collection('tasks').doc(taskId);
}

class FirestoreAPI {
  static final instance = FirestoreAPI();
  bool existsDBUser = false;

  Future<void> addTask(User user,
      {required String title, required String description, required DateTime until, required List<File> images}) async {
    final uid = user.uid;
    final taskId = _uuid.v5("uid", uid);

    final imageUUIDList = images.map((e) => _uuid.v4()).toList();
    final imagePathList = imageUUIDList.map((id) => "${uid}/$taskId/$id").toList();

    final taskData = Task.map(
        update: false, id: taskId, title: title, description: description, until: until, images: imagePathList, status: TaskStatus.undone);

    // Firestoreに追加

    // ユーザーを追加
    if (!existsDBUser) {
      final snapshot = await _users.doc(uid).get();
      existsDBUser = snapshot.exists;
      if (!snapshot.exists) {
        await addUser(user);
      }
    }

    await _taskRef(uid, taskId).set(taskData);
  }

  Future<void> addUser(User user) async {
    final userData = DBUser.map();
    await _users.doc(user.uid).set(userData);
    existsDBUser = true;
  }

  Future<void> deleteTask(User user, String taskId) {
    return _taskRef(user.uid, taskId).delete();
  }

  Future<void> updateTask(User user, String taskId, Map<String, dynamic> data) {
    return _taskRef(user.uid, taskId).withTaskConverter().update(data);
  }
}
