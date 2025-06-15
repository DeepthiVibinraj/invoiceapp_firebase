import 'package:flutter/material.dart';

class mandatoryText extends StatelessWidget {
  final String text;
  const mandatoryText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(text: text, style: textTheme.bodyMedium, children: [
        TextSpan(
            text: ' *',
            style: textTheme.titleMedium?.copyWith(color: Colors.red))
      ]),
    );
  }
}
