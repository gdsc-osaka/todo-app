import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/api/storage_provider.dart';
import 'package:todo_app/features/home/date_formatter.dart';
import 'package:todo_app/features/home/firestore_api.dart';
import 'package:todo_app/features/task_view/task_view_page.dart';

import '../../model/task.dart';

class DoneTaskListItem extends StatelessWidget {
  const DoneTaskListItem({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    onPressUndone() {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        FirestoreAPI.instance.updateTask(user, task.id, Task.map(update: true, status: TaskStatus.undone));
      }
    }

    onTap() {
      context.pushNamed(TaskViewPage.name, pathParameters: {TaskViewPage.idParam: task.id});
    }

    return Row(
      children: [
        const SizedBox(width: 16),
        const Icon(Icons.check),
        const SizedBox(width: 8),
        GestureDetector(onTap: onTap, child: Text(task.title, style: const TextStyle(decoration: TextDecoration.lineThrough))),
        const Expanded(child: SizedBox()),
        SizedBox(
          height: 36,
          child: OutlinedButton(onPressed: onPressUndone, child: const Text("戻す")),
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}

class DoneTaskList extends StatelessWidget {
  const DoneTaskList({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("完了済みタスク"),
      controlAffinity: ListTileControlAffinity.leading,
      children: tasks.map((task) => Padding(padding: const EdgeInsets.only(left: 12), child: DoneTaskListItem(task: task))).toList(),
    );
  }
}

class TaskListItem extends ConsumerStatefulWidget {
  const TaskListItem({super.key, required this.task});

  final Task task;

  @override
  ConsumerState<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends ConsumerState<TaskListItem> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final images = task.images;
    final until = task.until.toDate();

    const height = 100.0;

    onTap() {
      context.pushNamed(TaskViewPage.name, pathParameters: {TaskViewPage.idParam: task.id});
    }

    onTapCheck(bool? value) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && value != null) {
        FirestoreAPI.instance.updateTask(user, task.id, Task.map(update: true, status: value ? TaskStatus.completed : TaskStatus.undone));
      }
    }

    return SizedBox(
      height: height,
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(value: isDone, onChanged: onTapCheck),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(widget.task.title), Chip(label: Text(dateFormatter.format(until)))],
                ),
              ),
              images.isEmpty
                  ? const SizedBox()
                  : ref.watch(storageUrlProvider(images[0])).when(
                      data: (url) => Image.network(url, height: height, width: height, fit: BoxFit.cover),
                      error: (err, stack) => const Icon(Icons.error),
                      loading: () => const CircularProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => TaskListItem(task: tasks[index]),
      itemCount: tasks.length,
      shrinkWrap: true,
    );
  }
}
