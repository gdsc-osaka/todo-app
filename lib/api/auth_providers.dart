import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final isKeepAuthProvider = StateProvider<bool>((ref) => true);

final userChangesProvider = StreamProvider<User?>((ref) => );

final userProvider = FutureProvider((ref) => ref.watch(userChangesProvider.future));
