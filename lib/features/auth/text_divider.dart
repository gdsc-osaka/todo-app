import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider(
      {super.key, required this.child, this.height, this.thickness, this.indent, this.endIndent, this.color});

  final Widget child;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(endIndent: 10, indent: indent, height: height, thickness: thickness, color: color)),
        child,
        Expanded(child: Divider(indent: 10, endIndent: endIndent, height: height, thickness: thickness, color: color))
      ],
    );
  }
}
