import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    this.style,
    Key? key,
    this.type,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final int? type;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => type != null
          ? const LinearGradient(
              colors: [
                Color(0xFF505050), // darker gray

                Colors.white, // darker gray

                Color(0xFFB0B0B0), // light gray
                Color(0xFFFFFFFF), // pure white
                Color(0xFFFFD700), // lighter gold/orange
                Color(0xFFFF8C00), // strong orange
              ],
              stops: [0, 0.25, 0.5, 0.7, 0.85, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            )
          : const LinearGradient(
              colors: [
                Color(0xFF6BE3D7),
                Color(0xFFEEA2F5),
                Color(0xFFF6CAB3),
              ],
              stops: [0, 0.5, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
      child: Text(text, style: style),
    );
  }
}
