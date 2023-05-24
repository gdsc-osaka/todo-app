import 'package:flutter/cupertino.dart';

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
