import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/components/photo_icon.dart';
import 'package:todo_app/features/auth/auth_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const name = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoUrl = ref.watch(userProvider)?.photoURL;
    final userIcon = photoUrl != null ? PhotoIcon(photoUrl: photoUrl) : const Icon(Icons.person);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To-Do"),
        actions: [IconButton(onPressed: () {}, icon: userIcon)],
      ),
    );
  }
}
