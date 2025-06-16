import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  String text;
  HeaderText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      text,
      style: textTheme.headlineSmall
          ?.copyWith(color: Color.fromARGB(255, 52, 50, 50)),
    );
  }
}
