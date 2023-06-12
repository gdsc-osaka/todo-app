import 'package:flutter/material.dart';

class DatePickButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String date;

  const DatePickButton({super.key, required this.onPressed, required this.date});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return OutlinedButton(
        onPressed: onPressed,
        child: Text(date,
            style: TextStyle(color: color.onSurfaceVariant)));
  }
}