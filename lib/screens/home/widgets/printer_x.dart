import 'package:flutter/material.dart';

class PainterX extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4;
    canvas.drawLine(Offset(15, 15), Offset(35, 35), paint);
    canvas.drawLine(Offset(35, 15), Offset(15, 35), paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
