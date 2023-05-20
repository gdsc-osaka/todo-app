import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:todo_app/util/common_providers.dart';

final isKeepAuthProvider = StateNotifierProvider<BoolNotifier, bool>((ref) => BoolNotifier(true));

final userChangesProvider = StreamProvider((ref) => FirebaseAuth.instance.userChanges());

final isLoggedInProvider = Provider((ref) => ref.watch(userChangesProvider).value != null);
