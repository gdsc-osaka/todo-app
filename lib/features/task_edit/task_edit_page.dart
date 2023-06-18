import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/components/date_pick_button.dart';
import 'package:todo_app/features/home/date_formatter.dart';
import 'package:todo_app/features/home/firestore_api.dart';
import 'package:todo_app/theme/input_decorations.dart';

import '../../api/auth_providers.dart';
import '../../components/image_list.dart';
import '../../util/input_decoration_ex.dart';
import '../image_view/image_view_page.dart';
import 'task_detail_row.dart';

class TaskEditPage extends ConsumerStatefulWidget {
  const TaskEditPage({super.key});

  static const name = "/edit-task";

  @override
  ConsumerState<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends ConsumerState<TaskEditPage> {
  String title = "";
  String description = "";
  DateTime until = DateTime.now();
  List<XFile> imageFiles = [];

  @override
  Widget build(BuildContext context) {
    final isImagesEmpty = imageFiles.isEmpty;
    final strUntil = dateFormatter.format(until);
    final width = MediaQuery.of(context).size.width;
    final padding = width * 0.05;
    final theme = Theme.of(context);
    final text = theme.textTheme;

    pickImage() async {
      final pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (mounted) {
        setState(() {
          imageFiles = [...imageFiles, ...pickedFiles];
        });
      }
    }

    tapImage(int index) async {
      context.pushNamed(ImageViewPage.name, queryParameters: {ImageViewPage.pathParam: imageFiles[index].path});
    }

    tapUntil() async {
      const beforeYear = 100;
      const maxYear = 100;
      final picked = await showDatePicker(
          context: context, initialDate: until, firstDate: DateTime(until.year - beforeYear), lastDate: DateTime(until.year + maxYear));

      if (picked != null) {
        setState(() {
          until = picked;
        });
      }
    }

    addTask() async {
      final user = await ref.watch(userProvider.future);
      if (user != null) {
        await FirestoreAPI.instance
            .addTask(user, title: title, description: description, until: until, images: imageFiles.map((e) => File(e.path)).toList());

        if (mounted) {
          context.pop();
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("タスクを追加"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: padding, right: padding),
        child: Column(
          children: [
            const SizedBox(height: 14),
            TextFormField(
              decoration: simpleInputDecoration.merge(hintText: "タイトルを入力"),
              style: text.headlineSmall,
              onChanged: (value) => setState(() {
                title = value;
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "タイトルを入力してください";
                } else {
                  return null;
                }
              },
            ),
            TaskDetailRow(icon: const Icon(Icons.access_time), child: DatePickButton(onPressed: tapUntil, date: strUntil)),
            TaskDetailRow(
                icon: const Icon(Icons.table_rows),
                child: Expanded(
                  child: TextFormField(
                    decoration: simpleInputDecoration.merge(hintText: "詳細を入力"),
                    onChanged: (value) => setState(() {
                      description = value;
                    }),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                )),
            const SizedBox(height: 10),
            isImagesEmpty
                ? const SizedBox()
                : SizedBox(
                    height: 120,
                    child: ImageList(
                        imageProviders: imageFiles.map((e) => FileImage(File(e.path))).toList(),
                        tags: imageFiles.map((e) => e.path).toList(),
                        onPressedAdd: pickImage,
                        onPressedImage: tapImage,
                        canAdd: true),
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: isImagesEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
              children: [
                isImagesEmpty ? OutlinedButton(onPressed: pickImage, child: const Text("画像を追加")) : const SizedBox(),
                FilledButton(onPressed: addTask, child: const Text("追加")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
