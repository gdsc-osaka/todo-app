import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/model/with_converter_ex.dart';

import '../model/user.dart';
import 'auth_providers.dart';

final _db = FirebaseFirestore.instance;

final dbUserProvider = FutureProvider<DBUser?>((ref) async {
  final user = ref.watch(userProvider);

  if (user == null) {
    return Future.error('User not found.');
  } else {
    final uid = user.uid;
    final snapshot = await _db.collection('users').doc(uid).withUserConverter().get();
    final dbUser = snapshot.data();

    return dbUser;
  }
});
