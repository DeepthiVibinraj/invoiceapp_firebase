import 'package:flutter/material.dart';

class FormSubHead extends StatelessWidget {
  final String text;
  const FormSubHead({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.black54),
    );
  }
}
