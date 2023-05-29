import 'package:flutter/cupertino.dart';

class TaskDetailRow extends StatelessWidget {
  const TaskDetailRow({super.key, required this.icon, required this.child});

  final Widget icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Padding(padding: const EdgeInsets.only(top: 12, right: 12), child: icon), child],
      ),
    );
  }
}
