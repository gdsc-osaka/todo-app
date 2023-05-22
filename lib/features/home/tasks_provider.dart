import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/features/auth/auth_providers.dart';
import 'package:todo_app/model/with_converter_ex.dart';

import '../../model/task.dart';

final _db = FirebaseFirestore.instance;

final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final user = ref.watch(userProvider);

  if (user == null) {
    return Future.error('User not found.');
  } else {
    final uid = user.uid;
    final snapshot = await _db.collection('users').doc(uid).collection('tasks').withTaskConverter().get();
    final tasks = snapshot.docs.map((e) => e.data());

    return tasks.toList();
  }
});
