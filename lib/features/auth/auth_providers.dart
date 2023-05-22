import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final isKeepAuthProvider = StateProvider<bool>((ref) => true);

final userChangesProvider = StreamProvider((ref) => FirebaseAuth.instance.userChanges());

final userProvider = Provider((ref) => ref.watch(userChangesProvider).value);
