import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/components/photo_icon.dart';
import 'package:todo_app/features/home/task_list.dart';
import 'package:todo_app/features/task_edit/task_edit_page.dart';
import 'package:todo_app/model/task.dart';

import '../../api/auth_providers.dart';
import '../../api/tasks_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const name = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoUrl = ref.watch(userProvider).value?.photoURL;
    final userIcon = photoUrl != null ? PhotoIcon(photoUrl: photoUrl) : const Icon(Icons.person);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final width = MediaQuery.of(context).size.width;
    final padding = width * 0.05;

    tapAddTask() {
      context.push(TaskEditPage.name);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To-Do"),
        actions: [IconButton(onPressed: () {}, icon: userIcon)],
      ),
      body: ref.watch(allTaskProvider).when(
          data: (tasks) {
            // どのタスクもなし
            if (tasks.isEmpty) {
              return Center(
                child: Text('タスクはありません', style: text.titleLarge),
              );
            }

            final doneTasks = tasks.where((task) => task.status == TaskStatus.completed).toList();
            final undoneTasks = tasks.where((task) => task.status == TaskStatus.undone).toList();

            final children = <Widget>[];

            if (doneTasks.isNotEmpty) {
              children.addAll([
                DoneTaskList(tasks: doneTasks),
              ]);
            }

            if (undoneTasks.isNotEmpty) {
              if (doneTasks.isNotEmpty) {
                children.addAll([
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10)
                ]);
              }

              children.add(TaskList(tasks: undoneTasks));
            }

            return Column(children: children);
          },
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
