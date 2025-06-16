import 'package:flutter/material.dart';

class NonMandatoryText extends StatelessWidget {
  NonMandatoryText({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.titleMedium,
      // style: TextStyle(fontSize: Responsive.isMobile(context) ? 15 : 20),
    );
  }
}
