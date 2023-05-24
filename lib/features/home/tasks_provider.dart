import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/features/auth/auth_providers.dart';
import 'package:todo_app/model/with_converter_ex.dart';

import '../../model/task.dart';

final _db = FirebaseFirestore.instance;

final taskMapProvider = FutureProvider<Map<String, Task>>((ref) async {
  final user = ref.watch(userProvider);

  if (user == null) {
    return Future.error('User not found.');
  } else {
    final uid = user.uid;
    final snapshot = await _db.collection('users').doc(uid).collection('tasks').withTaskConverter().get();

    return {for (final e in snapshot.docs) e.id: e.data()};
  }
});

final tasksProvider = FutureProvider((ref) async {
  final taskMap = await ref.watch(taskMapProvider.future);

  return taskMap.values;
});

final taskProvider = FutureProvider.family<Task?, String>((ref, id) async {
  final taskMap = await ref.watch(taskMapProvider.future);
  final task = taskMap[id];

  return task;
});
