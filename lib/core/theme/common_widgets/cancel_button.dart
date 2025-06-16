import 'package:flutter/material.dart';
import 'package:toptalents/constants/constants.dart';

class CancelButton extends StatelessWidget {
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final BoxBorder? border;
  final Function? function;

  const CancelButton({
    Key? key,
    required this.function,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(defaultPadding),
    this.margin = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
    this.color,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Removes the border radius
        ),
      ),
      onPressed: () => function!(),
      child: Text('Cancel'),
    );
  }
}
