import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/features/home/date_formatter.dart';
import 'package:todo_app/features/home/firestore_api.dart';
import 'package:todo_app/util/callback.dart';

import '../auth/auth_providers.dart';
import '../image_view/image_view_page.dart';

class TaskEditPage extends ConsumerStatefulWidget {
  const TaskEditPage({super.key});

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

    pickImage() async {
      final pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (mounted) {
        setState(() {
          imageFiles = pickedFiles;
        });
      }
    }

    tapImage(int index) async {
      context.pushNamed(ImageViewPage.name, queryParameters: {ImageViewPage.pathParam: imageFiles[index].path});
    }

    tapUntil() async {
      const beforeYear = 100;
      const maxYear = 100;
      final picked = await showDatePicker(context: context, initialDate: until, firstDate: DateTime(until.year - beforeYear), lastDate: DateTime(until.year + maxYear));

      if (picked != null) {
        setState(() {
          until = picked;
        });
      }
    }

    addTask() async {
      final user = ref.watch(userProvider);
      if (user != null) {
        await FirestoreAPI.instance.addTask(user, title: title, description: description, until: until, images: imageFiles.map((e) => File(e.path)).toList());

        if (mounted) {
          context.pop();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("タスクを追加"),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: "タイトルを入力"),
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
          TaskDetailRow(icon: const Icon(Icons.access_time), child: Tooltip(onTriggered: tapUntil, child: Text(dateFormatter.format(until)))),
          TaskDetailRow(
              icon: const Icon(Icons.table_rows),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "詳細を入力"),
                onChanged: (value) => setState(() {
                  title = value;
                }),
              )),
          isImagesEmpty ? const SizedBox() : ImageList(imageFiles: imageFiles, onPressedAdd: pickImage, onPressedImage: tapImage),
          Row(
            mainAxisAlignment: isImagesEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
            children: [
              isImagesEmpty ? OutlinedButton(onPressed: pickImage, child: const Text("画像を追加")) : const SizedBox(),
              FilledButton(onPressed: addTask, child: const Text("追加")),
            ],
          )
        ],
      ),
    );
  }
}

class TaskDetailRow extends StatelessWidget {
  const TaskDetailRow({super.key, required this.icon, required this.child});

  final Widget icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [icon, child],
    );
  }
}

class ImageList extends StatelessWidget {
  const ImageList({super.key, required this.imageFiles, required this.onPressedAdd, required this.onPressedImage});

  final List<XFile> imageFiles;
  final VoidCallback onPressedAdd;
  final IndexCallback onPressedImage;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ImageListItem(
                onPressed: onPressedAdd,
                child: Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: onPressedAdd,
                  ),
                ));
          } else {
            final i = index - 1;
            final path = imageFiles[i].path;
            return ImageListItem(onPressed: () => onPressedImage(i), child: Hero(tag: path, child: Image.file(File(path))));
          }
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: imageFiles.length + 1);
  }
}

class ImageListItem extends StatelessWidget {
  const ImageListItem({super.key, required this.child, this.width, this.height, required this.onPressed});

  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(width: width ?? 100, height: height ?? 100, child: child),
      ),
    );
  }
}
