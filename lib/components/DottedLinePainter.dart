import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final double dashWidth; // Width of each dash
  final double dashSpace; // Space between dashes
  final Color color; // Color of the dashes
  final double dashHeight; // Height of each dash

  DashedLinePainter({this.dashWidth = 8.0, this.dashSpace = 4.0, this.color = Colors.black, this.dashHeight = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = dashHeight;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
