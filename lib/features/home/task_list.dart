import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/home/date_formatter.dart';
import 'package:todo_app/features/task_view/task_view_page.dart';

import '../../model/task.dart';

class DoneTaskListItem extends StatelessWidget {
  const DoneTaskListItem({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check),
        Text(task.title, style: const TextStyle(decoration: TextDecoration.lineThrough)),
        OutlinedButton(onPressed: () {}, child: const Text("戻す"))
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
      children: tasks.map((task) => Padding(padding: const EdgeInsets.only(left: 12), child: DoneTaskListItem(task: task))).toList(),
    );
  }
}

class TaskListItem extends StatefulWidget {
  const TaskListItem({super.key, required this.task});

  final Task task;

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final images = task.images;
    final photo = images.isEmpty ? const SizedBox() : Image.network(images[0]);
    final until = task.until.toDate();

    onTap() {
      context.goNamed(TaskViewPage.name, pathParameters: {TaskViewPage.idParam: task.id});
    }

    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(value: isDone, onChanged: (value) {}),
            Expanded(
              child: Column(
                children: [Text(widget.task.title), Chip(label: Text(dateFormatter.format(until)))],
              ),
            ),
            photo
          ],
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
    );
  }
}
