import 'package:flutter/material.dart';
import 'package:todo_app/features/home/date_formatter.dart';

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
    )
  }
}