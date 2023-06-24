import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/api/storage_provider.dart';
import 'package:todo_app/components/date_pick_button.dart';
import 'package:todo_app/api/firestore_api.dart';
import 'package:todo_app/features/task_edit/task_detail_row.dart';
import 'package:todo_app/theme/input_decorations.dart';

import '../../api/auth_providers.dart';
import '../../api/tasks_provider.dart';
import '../../components/image_list.dart';
import '../../model/task.dart';
import '../home/date_formatter.dart';
import '../image_view/image_view_page.dart';

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

                  if (mounted) {
                    context.pop();
                  }
                }
              }

              onTapImage(int index) async {
                final url = await ref.watch(storageUrlProvider(images[index]).future);
                if (mounted) {
                  context.pushNamed(ImageViewPage.name, queryParameters: {ImageViewPage.urlParam: url});
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
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverPadding(
                    padding: EdgeInsets.only(left: padding, right: padding),
                    sliver: SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: images.isNotEmpty
                            ? SizedBox(
                                height: 120,
                                child: ImageList(
                                    imageProviders: images
                                        .map((e) => NetworkImage(ref
                                            .watch(storageUrlProvider(e))
                                            .when(data: (url) => url, error: (err, stack) => "", loading: () => "")))
                                        .toList(),
                                    tags: images,
                                    onPressedAdd: () {},
                                    onPressedImage: onTapImage,
                                    canAdd: false),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: padding, right: padding),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(onPressed: onTapDelete, child: const Text('タスクを削除')),
                          task.status != TaskStatus.completed
                              ? FilledButton(onPressed: onTapComplete, child: const Text('完了とする'))
                              : const SizedBox(),
                        ],
                      ),
                    ),
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
