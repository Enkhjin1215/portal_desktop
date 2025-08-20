import 'package:flutter/widgets.dart';

class BottomRightRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0); // Top-left
    path.lineTo(size.width, 0); // Top-right
    path.lineTo(size.width, size.height - 20); // Move to bottom-right (before curve)
    path.quadraticBezierTo(
      size.width, size.height, // Control point
      size.width - 30, size.height, // End of curve
    );
    path.lineTo(0, size.height); // Bottom-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
