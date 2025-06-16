import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  final bool isTop;
  WaveClipper({this.isTop = true});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (isTop) {
      path.lineTo(0, size.height - 40);
      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2, size.height - 40);
      var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, 40);
      var firstControlPoint = Offset(size.width / 4, 0);
      var firstEndPoint = Offset(size.width / 2, 40);
      var secondControlPoint = Offset(size.width * 3 / 4, 80);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
