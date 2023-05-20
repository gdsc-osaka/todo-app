import 'package:riverpod/riverpod.dart';

class BoolNotifier extends StateNotifier<bool> {
  BoolNotifier(super.state);

  void setState(bool value) {
    state = value;
  }
}
