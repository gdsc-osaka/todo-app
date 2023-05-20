import 'package:riverpod/riverpod.dart';
import 'package:todo_app/util/common_providers.dart';

final isKeepAuthProvider = StateNotifierProvider<BoolNotifier, bool>((ref) => BoolNotifier(true));
