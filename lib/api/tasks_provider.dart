import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/api/auth_providers.dart';

import '../../model/task.dart';

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

final allTaskProvider = StreamProvider.autoDispose<List<Task>>((ref) {
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

/// 特定のタスクのStreamを渡す
final taskProvider = StreamProvider.autoDispose.family<Task, String>((ref, taskId) {
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