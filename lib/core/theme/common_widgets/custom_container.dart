import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final BoxBorder? border;

  const CustomContainer({
    Key? key,
    required this.child,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
    this.color,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.indigo[50],
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: child,
    );
  }
}
