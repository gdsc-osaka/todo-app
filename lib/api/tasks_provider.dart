import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/api/auth_providers.dart';
import 'package:todo_app/model/with_converter_ex.dart';

import '../../model/task.dart';

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

final tasksStreamProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  return ref.watch(userProvider).when(
      data: (user) {
        if (user == null) {
          return const Stream.empty();
        } else {
          final uid = user.uid;
          final ref = _db.collection('users').doc(uid).collection('tasks');

          // ref.snapshots().listen((event) {
          //   final data = event.docs;
          // });

          final snapshots = ref.snapshots();

          return snapshots.map((snapshot) {
            final tasks = snapshot.docs
                .map((doc) {
                  final data = doc.data();

                  if (data.containsKey('updatedAt') && data['updatedAt'] == null) {
                    data['updatedAt'] = Timestamp.fromDate(DateTime.now());
                  }

                  return Task.fromJson(data);
            }).toList();

            return tasks;
          });
        }
      },
      error: (err, stack) => const Stream.empty(),
      loading: () => const Stream.empty());
});

final allTasksProvider = FutureProvider.autoDispose((ref) async {
  final tasks = await ref.watch(tasksStreamProvider.future);

  return tasks;
});

final taskMapProvider = FutureProvider.autoDispose<Map<String, Task>>((ref) async {
  final user = await ref.watch(userProvider.future);

  if (user == null) {
    return Future.error('User not found.');
  } else {
    final uid = user.uid;
    final snapshot = await _db.collection('users').doc(uid).collection('tasks').withTaskConverter().get();

    return {for (final e in snapshot.docs) e.id: e.data()};
  }
  // final tasks = await ref.watch(allTasksProvider.future);
  // return Map.fromIterables(tasks.map((e) => e.id), tasks);
});

final taskProvider = FutureProvider.autoDispose.family<Task?, String>((ref, id) async {
  final taskMap = await ref.watch(taskMapProvider.future);
  final task = taskMap[id];

  return task;
});

/// 特定のタスクのStreamを渡す
final taskStreamProvider = StreamProvider.autoDispose.family<Task, String>((ref, taskId) {
  final user = _auth.currentUser;
  
  if (user == null) {
    return const Stream.empty();
  } else {
    final uid = user.uid;
    final ref = _db.collection('users').doc(uid).collection('tasks').doc(taskId);
    final data = ref.snapshots().map((event) {
      final data = event.data();

      if (data == null) {
        return null;
      }
      
      if (data.containsKey('updatedAt') && data['updatedAt'] == null) {
        data['updatedAt'] = Timestamp.fromDate(DateTime.now());
      }
      
      return Task.fromJson(data);
    }).where((task) => task != null).cast<Task>();

    return data;
  }
});