import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField detailsTextformfield(
  TextEditingController detailsController,
  BuildContext context,
  String hintText,
  String key,
) {
  final textTheme = Theme.of(context).textTheme;

  return TextFormField(
    maxLines: 4,
    key: ValueKey(key),
    validator: (value) {
      return null;
    },
    controller: detailsController,
    keyboardType: TextInputType.multiline,
    inputFormatters: [
      LengthLimitingTextInputFormatter(150),
    ],
    decoration: InputDecoration(
      errorStyle: const TextStyle(color: Colors.red),
      hintText: hintText,
      hintStyle: textTheme.labelLarge?.copyWith(color: Colors.grey),
    ),
  );
}
