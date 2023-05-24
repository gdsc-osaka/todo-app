import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/components/photo_icon.dart';
import 'package:todo_app/features/auth/auth_providers.dart';
import 'package:todo_app/features/home/task_list.dart';
import 'package:todo_app/features/home/tasks_provider.dart';
import 'package:todo_app/features/task_edit/task_edit_page.dart';
import 'package:todo_app/model/task.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const name = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoUrl = ref.watch(userProvider)?.photoURL;
    final userIcon = photoUrl != null ? PhotoIcon(photoUrl: photoUrl) : const Icon(Icons.person);

    tapAddTask() {
      context.push(TaskEditPage.name);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To-Do"),
        actions: [IconButton(onPressed: () {}, icon: userIcon)],
      ),
      body: ref.watch(tasksProvider).when(
          data: (tasks) => Column(
                children: [
                  DoneTaskList(tasks: tasks.where((task) => task.status == TaskStatus.completed).toList()),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  TaskList(tasks: tasks.where((task) => task.status == TaskStatus.undone).toList())
                ],
              ),
          error: (err, stack) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        onPressed: tapAddTask,
        tooltip: "タスクを追加",
        child: const Icon(Icons.edit),
      ),
    );
  }
}
