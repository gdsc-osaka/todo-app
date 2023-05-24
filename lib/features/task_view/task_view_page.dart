import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/features/home/tasks_provider.dart';
import 'package:todo_app/features/task_edit/task_detail_row.dart';

import '../home/date_formatter.dart';

class TaskViewPage extends ConsumerStatefulWidget {
  const TaskViewPage({Key? key, required this.taskId}) : super(key: key);

  final String taskId;

  @override
  TaskViewPageState createState() => TaskViewPageState();
}

class TaskViewPageState extends ConsumerState<TaskViewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    onChangeTitle(String? value) {}

    onTapUntil(DateTime until) async {
      const beforeYear = 100;
      const maxYear = 100;
      final picked = await showDatePicker(
          context: context, initialDate: until, firstDate: DateTime(until.year - beforeYear), lastDate: DateTime(until.year + maxYear));
    }

    return Scaffold(
      body: ref.watch(taskProvider(widget.taskId)).when(
          data: (task) {
            if (task == null) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('タスクが見つかりません', style: text.headlineSmall),
                    const SizedBox(height: 14),
                    OutlinedButton(onPressed: () => context.pop, child: const Text('戻る'))
                  ],
                ),
              );
            } else {
              final until = task.until.toDate();

              return CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    floating: true,
                    pinned: true,
                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: Text(task.title),
                  ),
                  SliverList.list(
                    children: [
                      TaskDetailRow(
                          icon: const Icon(Icons.access_time),
                          child: Tooltip(onTriggered: () => onTapUntil(until), child: Text(dateFormatter.format(until)))),
                      TaskDetailRow(
                          icon: const Icon(Icons.table_rows),
                          child: TextFormField(
                              decoration: const InputDecoration(hintText: "詳細を入力"),
                              initialValue: task.description,
                              onSaved: onChangeTitle)),
                    ],
                  ),
                  SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [],
                  )
                ],
              );
            }
          },
          error: (err, stack) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
