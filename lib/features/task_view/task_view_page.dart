import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/components/date_pick_button.dart';
import 'package:todo_app/features/home/firestore_api.dart';
import 'package:todo_app/features/task_edit/task_detail_row.dart';
import 'package:todo_app/theme/input_decorations.dart';

import '../../api/auth_providers.dart';
import '../../api/storage_provider.dart';
import '../../api/tasks_provider.dart';
import '../../model/task.dart';
import '../home/date_formatter.dart';

class TaskViewPage extends ConsumerStatefulWidget {
  const TaskViewPage({Key? key, required this.taskId}) : super(key: key);

  static const name = '/task-view';
  static const path = '/task-view/:id';
  static const idParam = 'id';

  final String taskId;

  @override
  TaskViewPageState createState() => TaskViewPageState();
}

class TaskViewPageState extends ConsumerState<TaskViewPage> {
  final _db = FirestoreAPI.instance;

  final titleEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final taskId = widget.taskId;
    final width = MediaQuery.of(context).size.width;
    final padding = width * 0.05;

    return Scaffold(
      body: ref.watch(taskProvider(taskId)).when(
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
              final user = ref.watch(userProvider).value;
              final images = task.images;

              if (titleEditingController.text.isEmpty) {
                titleEditingController.text = task.title;
              }

              onChangeTitle(String? value) {
                if (user != null) {
                  if (value != task.title) {
                    _db.updateTask(user, taskId, Task.map(update: true, title: value));
                  }
                }
              }

              onChangeDescription(String? value) {
                if (user != null && value != null) {
                  _db.updateTask(user, taskId, Task.map(update: true, description: value));
                }
              }

              onTapUntil() async {
                const beforeYear = 100;
                const maxYear = 100;
                final picked = await showDatePicker(
                    context: context,
                    initialDate: until,
                    firstDate: DateTime(until.year - beforeYear),
                    lastDate: DateTime(until.year + maxYear));

                if (user != null) {
                  _db.updateTask(user, taskId, Task.map(update: true, until: picked));
                }
              }

              onTapDelete() async {
                if (user != null) {
                  await _db.deleteTask(user, taskId);

                  if (mounted) {
                    context.pop();
                  }
                }
              }

              onTapComplete() {
                if (user != null) {
                  _db.updateTask(user, taskId, Task.map(update: true, status: TaskStatus.completed));
                }
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    floating: true,
                    pinned: true,
                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: TextFormField(
                        controller: titleEditingController,
                        onFieldSubmitted: onChangeTitle,
                        decoration: simpleInputDecoration,
                        style: text.headlineSmall),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: padding, right: padding),
                    sliver: SliverList.list(
                      children: [
                        TaskDetailRow(
                            icon: const Icon(Icons.access_time),
                            child: DatePickButton(onPressed: onTapUntil, date: dateFormatter.format(until))),
                        TaskDetailRow(
                            icon: const Icon(Icons.table_rows),
                            child: Expanded(
                              child: TextFormField(
                                  decoration: const InputDecoration(hintText: "詳細を入力"),
                                  initialValue: task.description,
                                  onFieldSubmitted: onChangeDescription),
                            )),
                      ],
                    ),
                  ),
                  SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: task.images
                        .map((imagePath) => ref.watch(storageUrlProvider(imagePath)).when(
                            data: (url) => Image.network(url),
                            error: (err, stack) => Text(err.toString()),
                            loading: () => const CircularProgressIndicator()))
                        .toList(),
                  ),
                  // SliverToBoxAdapter(
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       OutlinedButton(onPressed: onTapDelete, child: const Text('タスクを削除')),
                  //       FilledButton(onPressed: onTapComplete, child: const Text('完了とする')),
                  //     ],
                  //   ),
                  // )
                ],
              );
            }
          },
          error: (err, stack) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
