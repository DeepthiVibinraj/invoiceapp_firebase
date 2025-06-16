import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField customTextFormField(
  BuildContext context,
  ColorScheme colorScheme,
  TextTheme textTheme,
  TextEditingController controller,
  String hintText,
  TextInputType type,
  String? Function() validator,
  String val,
  String key,
  bool readOnly,
) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    inputFormatters: [
      //LengthLimitingTextInputFormatter(50),
      if (type == TextInputType.number)
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      if (type == TextInputType.phone) LengthLimitingTextInputFormatter(10),
      if (type == TextInputType.phone)
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      if (type == TextInputType.name)
        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z\s]')),
    ],
    readOnly: readOnly,
    validator: (value) {
      return validator();
    },
    onEditingComplete: () {},
    decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        hintText: hintText,
        hintStyle: textTheme.labelLarge?.copyWith(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
  );
}
