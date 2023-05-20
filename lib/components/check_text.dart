import 'package:flutter/material.dart';

class CheckText extends StatelessWidget {
  const CheckText(
      {super.key, required this.child, required this.value, required this.onChanged, this.mainAxisAlignment});

  final Widget child;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        child,
      ],
    );
  }
}
