import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/features/home/date_formatter.dart';
import 'package:todo_app/util/callback.dart';

class TaskEditPage extends StatefulWidget {
  const TaskEditPage({super.key});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
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
          TaskDetailRow(
              icon: const Icon(Icons.access_time),
              child: Tooltip(child: Text(dateFormatter.format(until)), onTriggered: () {})
          ),
          TaskDetailRow(
              icon: const Icon(Icons.table_rows),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "詳細を入力"),
                onChanged: (value) => setState(() {
                  title = value;
                }),
              )
          ),
          isImagesEmpty
              ? const SizedBox()
              : ImageList(
                  imageFiles: imageFiles,
                  onPressedAdd: pickImage,
                  onPressedImage: () {}
          ),
          Row(
            mainAxisAlignment: isImagesEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
            children: [
              isImagesEmpty
                  ? OutlinedButton(onPressed: pickImage, child: const Text("画像を追加"))
                  : const SizedBox(),
              FilledButton(onPressed: () {}, child: const Text("追加")),
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
      children: [
        icon,
        child
      ],
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
                )
            );
          } else {
            final i = index - 1;
            return ImageListItem(
                onPressed: () => onPressedImage(i),
                child: Image.file(File(imageFiles[i].path))
            );
          }
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: imageFiles.length + 1
    );
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
        child: SizedBox(
          width: width ?? 100,
          height: height ?? 100,
          child: child
        ),
      ),
    );
  }
}