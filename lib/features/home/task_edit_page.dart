import 'package:flutter/material.dart';

class TaskEditPage extends StatefulWidget {
  const TaskEditPage({super.key});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  String title = "";
  String description = "";
  DateTime until = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
          )
        ],
      ),
    );
  }
}
