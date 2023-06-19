import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/api/auth_providers.dart';

import '../../model/task.dart';

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

final allTaskProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  return Stream.empty();
});

/// 特定のタスクのStreamを渡す
final taskProvider = StreamProvider.autoDispose.family<Task, String>((ref, taskId) {
  return Stream.empty();
});